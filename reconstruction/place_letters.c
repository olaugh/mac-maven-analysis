#include "place_letters.h"
#include "board_state.h"
static int16_t signed_byte(uint8_t value) {
    return value < 128 ? value : (int16_t)value - 256;
}
MavenPlacementResult maven_place_move_letters(const uint8_t *move, MavenLetterPlacement *s) {
    int16_t row = signed_byte(move[32]), column = signed_byte(move[33]), cross_row, cross_column;
    MavenPlacementResult result = {1, 0};
    const uint8_t *letter = move;
    maven_cross_coordinates(row, column, &cross_row, &cross_column);
    for (; *letter; ++letter, ++column, ++cross_row) {
        unsigned primary = (unsigned)(row * 17 + column),
                 cross = (unsigned)(cross_row * 17 + cross_column);
        if (letter - move >= 15)
            s->diagnostic(s->user);
        if (s->board[primary] != *letter && s->board[primary])
            s->diagnostic(s->user);
        if (s->board[cross] != *letter && s->board[cross])
            s->diagnostic(s->user);
        if (!s->board[primary]) {
            if (!s->counts[*letter]) {
                if (signed_byte(s->counts['?']) <= 0)
                    s->diagnostic(s->user);
                --s->counts['?'];
            } else
                --s->counts[*letter];
            s->undo[result.undo_end++] = (uint8_t)column;
            s->board[cross] = *letter;
            s->board[primary] = *letter;
            s->values[cross] = s->letter_values[*letter];
            s->values[primary] = s->letter_values[*letter];
            if (s->premium_codes[primary] == 3) {
                uint16_t bits = (uint16_t)((uint16_t)move[18] << 8 | move[19]);
                result.special_score =
                    bits < 32768 ? (int16_t)bits : (int16_t)((int32_t)bits - 65536);
            }
        }
    }
    return result;
}
