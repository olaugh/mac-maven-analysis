#include "exchange_candidates.h"
#include "rack_masks.h"
#include <string.h>

static int16_t signed_word(uint16_t bits) {
    return bits < 32768 ? (int16_t)bits : (int16_t)((int32_t)bits - 65536);
}
static void write_long(uint8_t *p, int16_t value) {
    uint32_t bits = (uint32_t)(int32_t)value;
    p[0] = (uint8_t)(bits >> 24);
    p[1] = (uint8_t)(bits >> 16);
    p[2] = (uint8_t)(bits >> 8);
    p[3] = (uint8_t)bits;
}
void maven_generate_exchange_candidates(MavenExchangeCandidates *state) {
    uint8_t move[34] = {0}, exchange[8];
    int16_t letter_values[128] = {0};
    uint32_t position_bits[7] = {1, 2, 4, 8, 16, 32, 64};
    const uint8_t *letter;
    int i;
    for (letter = state->rack; *letter; ++letter)
        letter_values[*letter] = state->adjusted_letter_value(state->user, *letter);
    for (i = 0; i < state->mask_count; ++i) {
        uint16_t kept = (uint16_t)state->canonical_masks[i];
        uint16_t difference, adjustment = 0;
        int16_t correction;
        move[30] = (uint8_t)(kept >> 8);
        move[31] = (uint8_t)kept;
        write_long(move + 20,
                   signed_word((uint16_t)(state->leave_values[kept] + state->leave_offset)));
        difference = maven_canonical_mask_difference(127, kept, state->sorted_rack,
                                                     state->diagnostic, state->user);
        maven_rack_from_mask(exchange, state->sorted_rack, position_bits, (int16_t)difference,
                             state->canonical_masks, state->mask_count, state->diagnostic,
                             state->user);
        strcpy((char *)move, (const char *)exchange);
        for (letter = exchange; *letter; ++letter)
            adjustment = (uint16_t)(adjustment - (uint16_t)letter_values[*letter]);
        adjustment = (uint16_t)(adjustment + adjustment);
        correction = (int16_t)(signed_word(adjustment) / (state->unseen_total - 7));
        if (state->opening)
            correction = signed_word((uint16_t)((uint16_t)correction + state->opening_score_zero -
                                                state->opening_score_five));
        write_long(move + 24, correction);
        state->candidate(state->user, move);
    }
    if (state->retained_count && *state->retained_count)
        *state->retained_count = 1;
}
