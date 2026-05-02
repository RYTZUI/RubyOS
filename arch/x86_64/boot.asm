section .multiboot
align 4
    dd 0x1BADB002            ; Magic
    dd 0x00                  ; Flags
    dd -(0x1BADB002 + 0x00)  ; Checksum

section .text
bits 32
global _start
_start:
    cli
    mov ax, 0x13             ; Switch to VGA Graphics Mode
    int 0x10
    mov esp, stack_top
    extern kernel_main
    call kernel_main
.halt: hlt
    jmp .halt

section .bss
align 4096
stack_bottom: resb 16384
stack_top:
