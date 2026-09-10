#ifndef MAVEN_UNDO_MOVE_H
#define MAVEN_UNDO_MOVE_H
#include <stdint.h>
typedef struct {
    uint8_t *board;      /* 544 bytes */
    uint16_t *values;    /* 544 native words */
    const uint8_t *undo; /* row, positive column list, marker, saved C rack */
    int16_t *row_zero_count;
    void (*diagnostic)(void *);
    void *user;
} MavenMoveUndo;
/* CODE31 [0x642,0x71e). Requires valid workspace/cell indices and a rack
 * destination large enough for the saved string. Does not rebuild counts. */
void maven_undo_move(uint8_t *rack, MavenMoveUndo *state);
#endif
