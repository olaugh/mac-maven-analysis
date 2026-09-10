#ifndef MAVEN_OPENING_PLACEMENTS_H
#define MAVEN_OPENING_PLACEMENTS_H
#include "dictionary_lookup.h"
#include <stddef.h>

typedef struct {
    uint8_t word[16];
    uint8_t row, column;
    uint32_t adjustment_bits;
    int16_t section;
} MavenOpeningPlacement;

typedef struct {
    const MavenDictionarySection *sections; /* Zero-root terminator. */
    uint8_t remaining[128];
    const uint8_t *vowel_characters;   /* Original CODE23+4 character set. */
    const uint8_t *letter_multipliers; /* 544-byte paired board. */
    const uint8_t *word_multipliers;
    void (*placement)(void *user, const MavenOpeningPlacement *, const uint8_t remaining[128]);
    void *user;
} MavenOpeningEnumeration;

/* CODE37[0x24e,0x36c) and the opening branch's dictionary iteration. Enumerate
 * dictionary words formable from rack, then every row8 placement covering the
 * center. Real letter tiles are consumed before blanks; blank assignment to
 * individual squares is deferred to the evaluator. Preserve section order,
 * DAWG sibling/child traversal order and increasing column order. Callback is
 * the CODE37+0xe46 evaluation boundary, not the final ranked-move callback.
 * Valid original dictionaries/racks (<=7 tiles, ASCII letters, acyclic DAWG)
 * required. Callback must not mutate enumeration state. Counts are restored.
 * Exclusion dictionary, scoring, rack leave and ranking are NOT included. */
void maven_enumerate_opening_placements(MavenOpeningEnumeration *state);
#endif
