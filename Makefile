x86_64_asm_source_files := $(shell find src/impl/x86_64 -name *.asm)
x86_64_asm_object_files := $(patsubst src/impl/x86_64/%.asm, build/x86_64/%.o, $(x86_64_asm_source_files))

build/x86_64/%.o : src/impl/x86_64/%.asm
	@mkdir -p $(dir $@)
	nasm -f elf64 $< -o $@

.PHONY: build-x86_64
build-x86_64: $(x86_64_asm_object_files)
	@mkdir -p dist/x86_64
	x86_64-elf-ld -n -o dist/x86_64/kernel.bin -T target/x86_64/linker.ld $(x86_64_asm_object_files)
	cp dist/x86_64/kernel.bin target/x86_64/iso/boot/kernel.bin
	grub-mkrescue -o dist/x86_64/kernel.iso target/x86_64/iso
