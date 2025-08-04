[BITS 16]
[ORG 0x7c00]

CODE_OFFSET equ 0x8
DATA_OFFSET equ 0x10

start: 
    cli ; Clear Interrupts
    mov ax, 0x00
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti ; Enable Interrupts


load_PM:
    cli
    lgdt[gdt_descriptor]
    mov eax, cr0
    or al, 1
    mov cr0, eax
    jmp CODE_OFFSET:PModeMain

gdt_start: 
    dd 0x00000000
    dd 0x00000000

    ; Code Segment Descriptor
    dw 0xFFFF       ; Limit
    dw 0x0000       ; Base
    dw 0x00         ; Base
    db 10011010b    ; Access Byte
    db 11001111b    ; Flags 
    db 0x00         ; Base
    
    ; Data Segment Descriptor
    dw 0xFFFF       ; Limit
    dw 0x0000       ; Base
    dw 0x00         ; Base
    db 10010010b    ; Access Byte
    db 11001111b    ; Flags 
    db 0x00         ; Base

gdt_end: 

gdt_descriptor: 
    dw gdt_end - gdt_start - 1
    dd gdt_start

[BITS 32]



times 510 - ($ - $$) db 0


dw 0xAA55