#include "undo_move.h"
#include "board_state.h"
#include <string.h>
static int16_t signed_byte(uint8_t b) {
    return b < 128 ? b : (int16_t)b - 256;
}
void maven_undo_move(uint8_t *rack, MavenMoveUndo *s) {
    int16_t row = signed_byte(s->undo[0]), column, cross_row, cross_column;
    unsigned index = 1;
    if (!row) {
        uint16_t bits;
        if (s->undo[1] != 255)
            s->diagnostic(s->user);
        if (s->board[0] && strlen((const char *)s->undo + 2) != 7)
            s->diagnostic(s->user);
        bits = (uint16_t)((uint16_t)*s->row_zero_count - 1);
        *s->row_zero_count = bits < 32768 ? (int16_t)bits : (int16_t)((int32_t)bits - 65536);
        memset(s->board, 0, 17);
    } else {
        while ((column = signed_byte(s->undo[index])) > 0) {
            unsigned primary = (unsigned)(row * 17 + column), cross;
            maven_cross_coordinates(row, column, &cross_row, &cross_column);
            cross = (unsigned)(cross_row * 17 + cross_column);
            s->board[cross] = 0;
            s->board[primary] = 0;
            s->values[cross] = 0;
            s->values[primary] = 0;
            ++index;
        }
    }
    strcpy((char *)rack, (const char *)s->undo + index + 1);
}
