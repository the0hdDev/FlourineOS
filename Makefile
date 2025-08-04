all:
	nasm -f bin ./bootloader/src/boot.asm -o ./bootloader/bin/boot.bin

clean: 
	rm -rf ./bootloader/bin/boot.bin