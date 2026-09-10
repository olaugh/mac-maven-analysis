#include "cross_word_possible.h"
#include "board_state.h"
int16_t maven_cross_word_possible(const int16_t available[128], const uint8_t *alphabet,
                                  int16_t row, int16_t column, uint8_t board[544],
                                  int32_t (*contains)(void *, const uint8_t *),
                                  void (*diagnostic)(void *), void *user) {
    int16_t cross_row, cross_column;
    uint8_t *cell;
    const uint8_t *start, *letter;
    int index = 17 * row + column;
    if (board[index])
        diagnostic(user);
    if (!(row != 16 && board[index - 17]) && !(row != 15 && board[index + 17]))
        diagnostic(user);
    maven_cross_coordinates(row, column, &cross_row, &cross_column);
    cell = board + 17 * cross_row + cross_column;
    start = maven_word_start_before(board, cross_row, cross_column);
    if (!((start == cell && !*start) || (*start && !start[-1])))
        diagnostic(user);
    for (letter = alphabet; *letter; ++letter) {
        if (!available[*letter])
            continue;
        *cell = *letter;
        if (contains(user, start)) {
            *cell = 0;
            return 1;
        }
    }
    *cell = 0;
    return 0;
}
