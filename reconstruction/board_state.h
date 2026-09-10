#ifndef MAVEN_BOARD_STATE_H
#define MAVEN_BOARD_STATE_H
#include <stdint.h>
/* CODE 31+0x78. Maps one orientation to the other using signed words. */
void maven_cross_coordinates(int16_t row, int16_t column, int16_t *cross_row,
                             int16_t *cross_column);
/* CODE 31+0xde scans bytes [17,272), including row-border slots. */
int16_t maven_count_board_bytes(const uint8_t board[544]);
int16_t maven_board_at_most_79(const uint8_t board[544]);
int16_t maven_board_at_least_86(const uint8_t board[544]);
/* CODE 31+0xb2. Counter is A5-0x4c0e: incremented by row-zero moves,
 * cleared by ordinary placements. Its exact semantic name is still pending. */
int16_t maven_game_end_check(const uint8_t *rack0, const uint8_t *rack1, int16_t row_zero_count,
                             const uint8_t board[544]);

/* CODE31 [4,0x4c): count empty cells underneath the move's word string.
 * Valid move coordinates/length required; does not validate letter matches. */
int16_t maven_count_new_move_tiles(const uint8_t *move, const uint8_t board[544]);
/* CODE31 [0x4c,0x78): start immediately LEFT of (row,column), scan to an
 * empty byte, then return the following cell. Requires an in-buffer zero
 * sentinel; does not test the supplied cell before scanning. */
const uint8_t *maven_word_start_before(const uint8_t board[544], int16_t row, int16_t column);

#endif
