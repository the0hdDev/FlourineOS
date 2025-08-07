#pragma once

#include <stdint.h>
#include <stddef.h>

enum {
    PRINT_COLOR_BLACK = 0,
    PRINT_COLOR_RED = 1,
    PRINT_COLOR_GREEN = 2,
    PRINT_COLOR_YELLOW = 3,
    PRINT_COLOR_BLUE = 4,
    PRINT_COLOR_MAGENTA = 5,

};

namespace std {
    void print_clear();
    void print_char(char character);
    void print_str(char* string);
    void print_set_color(PRINT_COLOR color);
}
