//
// Created by theo on 8/7/25.
//
#include "kprintf.h"
#include "../driver/keyboard/ps2/generic-ps2-host.h"

void kernel_main() {
    kprintSetColor(PRINT_COLOR_YELLOW, PRINT_COLOR_BLACK);
    kprintf("\nHello World!\0\n");
    for (int i = 0; i > 5; i++) {
        kprintf("Skibidi Ohio Sigma\n");
    }
    placeholder();
}