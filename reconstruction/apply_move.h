#ifndef MAVEN_APPLY_MOVE_H
#define MAVEN_APPLY_MOVE_H
#include "place_letters.h"
typedef struct {
    MavenLetterPlacement placement;
    const uint8_t *letter_multipliers;
    const uint8_t *letter_class;
    const uint8_t *alphabet;
    int16_t row_zero_count;
    int16_t new_tiles;
    int16_t recorded_row[2];
    int16_t recorded_column[2];
    /* Optional A5-0x4c12 callback receives a private 34-byte move copy whose
     * BE32 score at +16 has been replaced. Changes to it do not change the
     * original move passed to placement. user may reference this state. */
    void (*scored_move)(void *user, uint8_t move_copy[34]);
    void *callback_user;
} MavenApplyState;
/* Additional scorer outputs needed by the evaluated application postlude.
 * remaining is written only for a placement; a row-zero move preserves it,
 * matching the original stack slot. special_score is always initialized. */
typedef struct {
    uint8_t remaining[16];
    int16_t special_score;
} MavenAppliedMove;
void maven_apply_move_with_details(const uint8_t *move, uint8_t *rack,
                                    MavenApplyState *state, uint32_t bonus,
                                    MavenAppliedMove *details);
/* CODE31+0x184, evaluation flag ZERO only. Caller populated counts for rack.
 * Valid scorer/placement input contracts apply. Updates board/value/rack,
 * undo, counter and scorer globals; excludes refill, history, player totals
 * and the evaluation-only branches. Return register is not modeled as an API. */
void maven_apply_move_without_evaluation(const uint8_t *move, uint8_t *rack,
                                         MavenApplyState *state);
/* Same evaluation-zero path with the endgame-scaled bingo global. */
void maven_apply_move_with_bonus(const uint8_t *move, uint8_t *rack, MavenApplyState *state,
                                 uint32_t bonus);
#endif
