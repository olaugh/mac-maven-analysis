#ifndef MAVEN_DISPLAY_BOARD_H
#define MAVEN_DISPLAY_BOARD_H
#include <stdint.h>
/* CODE20+004e /0236 /0276: rebuild engine board from the15x15 display grid.
 * With force0, cells differing from previous are pending edits and omitted.
 * With force nonzero, all cells are accepted and previous is synchronized.
 * The raw character class high bit marks a blank; bit0x40 lowercases tiles.
 * ASCII input is validated before any mutation. Inputs must not alias outputs.
 * UI redraws are omitted. Returns0 for invalid input,1 after rebuilding. */
int maven_rebuild_display_board(const uint8_t display[289],uint8_t previous[289],
    int force,const uint8_t classes[128],const uint16_t letters[128],
    uint8_t board[544],uint16_t values[544]);
#endif
