#include "opening_placements.h"
#include <string.h>

static uint32_t node_word(const uint8_t *p) {
    return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3];
}
static int premium_exceeds_one(uint8_t value) {
    /* CMP.B/BGT: original comparison is signed. */
    return value > 1 && value < 128;
}
static uint32_t opening_adjustment(const MavenOpeningEnumeration *state, const uint8_t *word,
                                   size_t column) {
    uint32_t adjustment = 0;
    for (; *word; ++word, ++column) {
        if (strchr((const char *)state->vowel_characters, *word) &&
            (premium_exceeds_one(state->letter_multipliers[7 * 17 + column]) ||
             premium_exceeds_one(state->word_multipliers[7 * 17 + column]) ||
             premium_exceeds_one(state->letter_multipliers[9 * 17 + column]) ||
             premium_exceeds_one(state->word_multipliers[9 * 17 + column])))
            --adjustment;
    }
    return adjustment;
}
static void visit(MavenOpeningEnumeration *state, MavenOpeningPlacement *placement, size_t depth,
                  uint32_t index) {
    const uint8_t *records = state->sections[placement->section].records;
    uint32_t node;
    do {
        uint8_t letter, consumed;
        node = node_word(records + (size_t)index++ * 4);
        letter = (uint8_t)node;
        placement->word[depth] = letter;
        consumed = state->remaining[letter] ? letter : (uint8_t)'?';
        if (state->remaining[consumed]) {
            --state->remaining[consumed];
            if (node & 0x100) {
                size_t column;
                for (column = 8 - depth; column <= 8; ++column) {
                    placement->column = (uint8_t)column;
                    placement->adjustment_bits = opening_adjustment(state, placement->word, column);
                    state->placement(state->user, placement, state->remaining);
                }
                placement->adjustment_bits = 0;
            }
            if (node >> 10)
                visit(state, placement, depth + 1, node >> 10);
            ++state->remaining[consumed];
        }
    } while (!(node & 0x200));
    placement->word[depth] = 0;
}
void maven_enumerate_opening_placements(MavenOpeningEnumeration *state) {
    MavenOpeningPlacement placement = {{0}, 8, 0, 0, 0};
    for (; state->sections[placement.section].root_index; ++placement.section)
        visit(state, &placement, 0, (uint32_t)state->sections[placement.section].root_index);
}
