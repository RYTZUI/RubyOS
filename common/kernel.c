#include <stdint.h>
#include "../include/ruby_splash.h"

void draw_big_pixel(int x, int y, int size, uint8_t color) {
    uint8_t* screen = (uint8_t*)0xA0000;
    for(int i=0; i<size; i++) for(int j=0; j<size; j++) {
        int px = x + i; int py = y + j;
        if(px < 320 && py < 200) screen[py * 320 + px] = color;
    }
}

__attribute__((section(".kernel_code"))) void kernel_main() {
    uint8_t* screen = (uint8_t*)0xA0000;
    for(int i = 0; i < 64000; i++) screen[i] = 0;
    unsigned int size = (ruby_splash_ppm_len - 15 > 64000) ? 64000 : ruby_splash_ppm_len - 15;
    for (unsigned int i = 0; i < size; i++) screen[i] = ruby_splash_ppm[i + 15];
    int sx = 180; int sy = 80;
    draw_big_pixel(sx, sy, 15, 15); draw_big_pixel(sx+20, sy, 15, 15);
    draw_big_pixel(sx+40, sy, 15, 15); draw_big_pixel(sx+60, sy, 15, 15);
    while(1) { __asm__("hlt"); }
}