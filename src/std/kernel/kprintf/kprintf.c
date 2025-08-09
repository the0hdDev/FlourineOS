//
// Created by theo on 8/8/25.
//

#include "kprintf.h"

const static size_t NUM_COLS = 80;
const static size_t NUM_ROWS = 25;

struct Char {
    uint8_t character; 
    uint8_t color;
};

// Move these declarations to the top
struct Char* buffer = (struct Char*) 0xb8000;
size_t col = 0;
size_t row = 0; 
uint8_t color = PRINT_COLOR_WHITE | PRINT_COLOR_BLACK << 4;

void kclearRow(size_t row) {
    struct Char empty = (struct Char) {
        character: ' ',
        color: color,
    }; 
    for (size_t col = 0; col < NUM_COLS; col++)
    {
        buffer[col + NUM_COLS * row] = empty;
    }
}

void kprintClear() {
    for (size_t i = 0; i < NUM_ROWS; i++) 
    {
        kclearRow(i);
    }
}

void kprintNewLine() {
    col = 0;

    if (row < NUM_ROWS - 1) {
        row++;
        return;
    }

    for (size_t row = 1; row < NUM_ROWS; row++) {
        for (size_t col = 0; col < NUM_COLS; col++) {
            struct Char character = buffer[col + NUM_COLS * row];
            buffer[col + NUM_COLS * (row - 1)] = character; 
        }
    }
    kclearRow(NUM_ROWS - 1); // Fix: was NUM_COLS - 1
}

void kprintChar(char character) {
    if (character == '\n') {
        kprintNewLine(); 
        return;
    }
    if (col >= NUM_COLS) { // Fix: should be >= not >
        kprintNewLine(); 
    }
    buffer[col + NUM_COLS * row] = (struct Char) {
        character: (uint8_t) character, 
        color: color,
    }; 

    col++; 
}

void kprintf(char* str) {
    for (size_t i = 0; 1; i++) { 
        char character = str[i]; // Remove unnecessary cast

        if (character == '\0') { 
            return;
        } 
        kprintChar(character);
    }
}

void kprintSetColor(uint8_t foreground, uint8_t background) {
    color = foreground + (background << 4);
}