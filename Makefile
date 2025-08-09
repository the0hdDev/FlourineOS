# Compiler & Tools
CC := x86_64-elf-gcc
ASM := nasm
LD := x86_64-elf-ld

INCLUDE_DIRS := $(shell find src -type d -print | sed 's/^/-I /')

CFLAGS := $(INCLUDE_DIRS) -ffreestanding
ASFLAGS := -f elf64

all_c_source_files := $(shell find src -name "*.c")
all_c_object_files := $(patsubst src/%.c, build/%.o, $(all_c_source_files))

x86_64_asm_source_files := $(shell find src/impl/x86_64 -name "*.asm")
x86_64_asm_object_files := $(patsubst src/impl/x86_64/%.asm, build/x86_64/%.o, $(x86_64_asm_source_files))

all_object_files := $(all_c_object_files) $(x86_64_asm_object_files)

$(all_c_object_files): build/%.o : src/%.c
	mkdir -p $(dir $@) && \
	$(CC) -c $(CFLAGS) $< -o $@

$(x86_64_asm_object_files): build/x86_64/%.o : src/impl/x86_64/%.asm
	mkdir -p $(dir $@) && \
	$(ASM) $(ASFLAGS) $< -o $@

.PHONY: build-x86_64
build-x86_64: $(all_object_files)
	mkdir -p dist/x86_64 && \
	$(LD) -n -o dist/x86_64/kernel.bin -T linker.ld $(all_object_files) && \
	cp dist/x86_64/kernel.bin target/x86_64/iso/boot/kernel.bin && \
	grub-mkrescue /usr/lib/grub/i386-pc -o dist/x86_64/kernel.iso target/x86_64/iso


.PHONY: show-files
show-files:
	@echo "C source files:"
	@echo $(all_c_source_files)
	@echo "C object files:"
	@echo $(all_c_object_files)
	@echo "ASM source files:"
	@echo $(x86_64_asm_source_files)
	@echo "ASM object files:"
	@echo $(x86_64_asm_object_files)

.PHONY: clean
clean:
	rm -rf build/ dist/