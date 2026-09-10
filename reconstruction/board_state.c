#include "board_state.h"
static int16_t word(uint16_t bits) {
    return bits < 32768 ? (int16_t)bits : (int16_t)((int32_t)bits - 65536);
}
void maven_cross_coordinates(int16_t row, int16_t column, int16_t *cross_row,
                             int16_t *cross_column) {
    if (row < 16) {
        *cross_row = word((uint16_t)((uint16_t)column + 15));
        *cross_column = row;
    } else {
        *cross_row = column;
        *cross_column = word((uint16_t)((uint16_t)row - 15));
    }
}
int16_t maven_count_board_bytes(const uint8_t board[544]) {
    int16_t count = 0;
    unsigned i;
    for (i = 17; i < 272; ++i)
        if (board[i])
            ++count;
    return count;
}
int16_t maven_board_at_most_79(const uint8_t board[544]) {
    return maven_count_board_bytes(board) <= 79;
}
int16_t maven_board_at_least_86(const uint8_t board[544]) {
    return maven_count_board_bytes(board) >= 86;
}
int16_t maven_game_end_check(const uint8_t *rack0, const uint8_t *rack1, int16_t row_zero_count,
                             const uint8_t board[544]) {
    if (!rack1[0] || !rack0[0] || row_zero_count == 6)
        return 1;
    if (row_zero_count == 2 && !maven_board_at_most_79(board))
        return 1;
    return 0;
}
int16_t maven_count_new_move_tiles(const uint8_t *move, const uint8_t board[544]) {
    int16_t row = move[32] < 128 ? move[32] : (int16_t)move[32] - 256;
    int16_t column = move[33] < 128 ? move[33] : (int16_t)move[33] - 256;
    const uint8_t *cell = board + row * 17 + column;
    uint16_t count = 0;
    while (*move++)
        if (!*cell++)
            ++count;
    return word(count);
}
const uint8_t *maven_word_start_before(const uint8_t board[544], int16_t row, int16_t column) {
    const uint8_t *cell = board + row * 17 + column - 1;
    while (*cell)
        --cell;
    return cell + 1;
}
