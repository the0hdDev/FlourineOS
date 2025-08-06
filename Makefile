FLAGS = -g -ffreestanding -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc -m32
FILES = ./build/kernel.asm.o ./build/kernel.o

all:
	rm -f ./bin/*
	rm -f ./build/*
	nasm -f bin ./src/boot.asm -o ./bin/boot.bin
	nasm -f elf -g ./src/kernel.asm -o ./build/kernel.asm.o
	i686-elf-g++ -I./src $(FLAGS) -std=gnu++17 -c ./src/kernel.cpp -o ./build/kernel.o
	i686-elf-ld -r $(FILES) -o ./build/completeKernel.o
	i686-elf-g++ $(FLAGS) -T ./Linkerscript.ld -o ./bin/kernel.bin -ffreestanding -O0 -nostdlib ./build/completeKernel.o
	cat ./bin/boot.bin ./bin/kernel.bin > ./bin/os.bin
	truncate -s 1474560 ./bin/os.bin
