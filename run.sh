#!/bin/bash
set -e  # Bei Fehler abbrechen

IMAGE_NAME="flourineos"
BUILD_DIR="$(pwd)"
KERNEL_ISO="./dist/x86_64/kernel.iso"
CONTAINER_WORKDIR="/root/env"

# 1. Prüfe ob das Image existiert
if ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
    echo "[INFO] Docker-Image '$IMAGE_NAME' nicht gefunden. Baue es jetzt..."
    sudo docker build buildenv -t "$IMAGE_NAME"
else
    sudo echo "[INFO] Docker-Image '$IMAGE_NAME' bereits vorhanden."
fi

# 2. Starte Container und führe Make aus
echo "[INFO] Starte Build im Docker-Container..."
sudo docker run --rm -it -v "$BUILD_DIR":"$CONTAINER_WORKDIR" -w "$CONTAINER_WORKDIR" "$IMAGE_NAME" make build-x86_64

# 3. Starte QEMU nur wenn ISO gebaut wurde
if [[ -f "$KERNEL_ISO" ]]; then
    echo "[INFO] Starte QEMU..."
    qemu-system-x86_64 -cdrom ./dist/x86_64/kernel.iso
else
    echo "[ERROR] ISO-Datei '$KERNEL_ISO' wurde nicht gefunden. Build war evtl. fehlerhaft."
    exit 1
fi
