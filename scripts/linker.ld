ENTRY(_start)
PHDRS {
    header PT_LOAD FLAGS(5); /* Read and Execute */
}
SECTIONS {
    . = 1M;
    .boot : {
        KEEP(*(.multiboot))
    } :header
    .text : { *(.text) } :header
    .rodata : { *(.rodata) } :header
    .data : { *(.data) }
    .bss : { *(.bss) }
}
