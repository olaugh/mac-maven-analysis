#include "opening_moves.h"
#include "rack_masks.h"
#include <string.h>

typedef struct {
    MavenOpeningMoves *state;
    uint16_t occurrence_masks[128][8];
} OpeningContext;

static void write_long(uint8_t *p, uint32_t value) {
    p[0] = (uint8_t)(value >> 24);
    p[1] = (uint8_t)(value >> 16);
    p[2] = (uint8_t)(value >> 8);
    p[3] = (uint8_t)value;
}
static void evaluate(void *user, const MavenOpeningPlacement *placement, const uint8_t *remaining) {
    OpeningContext *context = user;
    MavenOpeningMoves *state = context->state;
    uint8_t move[34] = {0}, residual[8], used[128] = {0};
    uint16_t mask = UINT16_MAX;
    size_t i;
    MavenScoreScan score;
    (void)remaining;
    /* CODE15+0x198 checks sections BEFORE the current one: cross-section
     * duplicate suppression, not a separate blacklist. */
    if (maven_counted_sections_contain(state->enumeration.sections, placement->section,
                                       placement->word))
        return;
    memcpy(move, placement->word, 16);
    move[32] = placement->row;
    move[33] = placement->column;
    score = maven_score_move(move, state->sorted_rack, residual, &state->scoring);
    for (i = 0; placement->word[i]; ++i) {
        uint8_t letter = placement->word[i];
        if (used[letter] == state->enumeration.remaining[letter])
            letter = '?';
        mask &= context->occurrence_masks[letter][used[letter]++];
    }
    write_long(move + 16, score.score_bits);
    write_long(move + 20, state->leave_values[mask] < 32768
                              ? state->leave_values[mask]
                              : UINT32_C(0xffff0000) | state->leave_values[mask]);
    write_long(move + 24, placement->adjustment_bits);
    move[29] = i == 7;
    move[30] = (uint8_t)(mask >> 8);
    move[31] = (uint8_t)mask;
    state->move(state->user, move);
}
void maven_generate_opening_moves(MavenOpeningMoves *state) {
    OpeningContext context;
    MavenOpeningEnumeration enumeration = state->enumeration;
    memset(&context, 0, sizeof context);
    context.state = state;
    maven_build_occurrence_masks(state->sorted_rack, context.occurrence_masks);
    enumeration.placement = evaluate;
    enumeration.user = &context;
    maven_enumerate_opening_placements(&enumeration);
}
