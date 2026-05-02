// RubyOS ARM64 Boot Entry
.section ".text.boot"

.global _start

_start:
    // 1. Identify the CPU Core
    // We only want the primary core to boot the kernel; others should sleep
    mrs     x0, mpidr_el1
    and     x0, x0, #0xFF        // Check the core ID
    cbz     x0, master_core      // If ID == 0, proceed to boot
    
halt:
    wfe                          // Wait for event (sleep)
    b       halt

master_core:
    // 2. Setup the Stack Pointer
    // RubyOS needs a place to store variables before C starts
    ldr     x0, =stack_top
    mov     sp, x0

    // 3. Clear the BSS section
    // (Ensures all uninitialized C variables start at zero)
    ldr     x0, =bss_start
    ldr     x1, =bss_end
    sub     x1, x1, x0
    cbz     x1, jump_to_kernel
clear_bss:
    str     xzr, [x0], #8
    subs    x1, x1, #8
    bne     clear_bss

jump_to_kernel:
    // 4. The Handshake: Jump to the shared C-Core
    // This is the same kernel_main used by x86_64
    bl      kernel_main

    // If kernel_main ever returns, halt the CPU
    b       halt

.section ".bss"
.align 16
bss_start:
    .skip 4096
bss_end:
stack_bottom:
    .skip 16384 // 16KB Stack for the C-Core
stack_top:
