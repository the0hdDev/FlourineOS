//
// Created by theo on 8/7/25.
//
#include "kprintf.h"


void kernel_main() {
    kprintSetColor(PRINT_COLOR_YELLOW, PRINT_COLOR_BLACK);
    kprintf("Hello World!\0\n");
}