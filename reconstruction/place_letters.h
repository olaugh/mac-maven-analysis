#ifndef MAVEN_PLACE_LETTERS_H
#define MAVEN_PLACE_LETTERS_H
#include <stdint.h>
typedef struct {
    uint8_t *board;                /* 544 bytes, both orientations */
    uint16_t *values;              /* 544 host words, not a guest-memory overlay */
    uint8_t *counts;               /* 128 ASCII byte counts; '?' is the blank alias */
    const uint16_t *letter_values; /* 128 entries */
    const uint8_t *premium_codes;  /* 544 entries */
    uint8_t *undo;                 /* 33-byte workspace; caller already set row at byte 0 */
    void (*diagnostic)(void *);
    void *user;
} MavenLetterPlacement;
typedef struct {
    int16_t undo_end;
    int16_t special_score;
} MavenPlacementResult;
/* CODE 31 [0x2f0,0x456): placement loop only. Excludes score helper,
 * counter reset, boundary-value cleanup, undo suffix, and rack rebuilding.
 * Valid ASCII word, nonzero row, and in-allocation coordinates required. */
MavenPlacementResult maven_place_move_letters(const uint8_t *move, MavenLetterPlacement *state);
#endif
