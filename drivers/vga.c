#include <stdint.h>

void vga_clear_screen(uint8_t color) {
    uint8_t* screen = (uint8_t*)0xA0000;
    for (int i = 0; i < 320 * 200; i++) screen[i] = color;
}

void vga_draw_pixel(int x, int y, uint8_t color) {
    uint8_t* screen = (uint8_t*)0xA0000;
    if (x >= 0 && x < 320 && y >= 0 && y < 200) screen[y * 320 + x] = color;
}