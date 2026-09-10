#include "move_finalize.h"
#include "board_state.h"
#include "rack_counts.h"
#include <string.h>
void maven_clear_recorded_move_values(uint16_t values[544], int16_t first_row, int16_t first_column,
                                      int16_t second_row, int16_t second_column) {
    int16_t row, column;
    /* Original order: A5-430a/-4306, then -430c/-4308; paired reverse. */
    values[first_row * 17 + first_column] = 0;
    values[second_row * 17 + second_column] = 0;
    maven_cross_coordinates(second_row, second_column, &row, &column);
    values[row * 17 + column] = 0;
    maven_cross_coordinates(first_row, first_column, &row, &column);
    values[row * 17 + column] = 0;
}
void maven_finish_move_rack(uint8_t undo[33], int16_t undo_end, uint8_t *rack,
                            const uint8_t counts[128], const uint8_t *alphabet,
                            void (*diagnostic)(void *), void *user) {
    undo[undo_end] = 255;
    /* Original compares unsigned long 31 against strlen(rack)+signed end. */
    if ((uint32_t)((uint32_t)strlen((const char *)rack) + (uint32_t)(int32_t)undo_end) >= 31)
        diagnostic(user);
    strcpy((char *)undo + undo_end + 1, (const char *)rack);
    maven_rack_from_counts(rack, counts, alphabet);
}
