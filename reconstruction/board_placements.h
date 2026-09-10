#ifndef MAVEN_BOARD_PLACEMENTS_H
#define MAVEN_BOARD_PLACEMENTS_H
#include "dictionary_lookup.h"
#include <stdint.h>

typedef struct {
    uint8_t word[16];
    uint8_t row, column;
    int16_t section;
} MavenBoardPlacement;
typedef struct {
    const MavenDictionarySection *sections;
    const uint8_t *board; /* Original 544-byte paired orientation board. */
    const uint8_t *letter_multipliers;
    const uint8_t *word_multipliers;
    uint8_t remaining[128];
    /* Optional 31-word array. Bit column restricts starting anchors, matching
     * CODE37+0x98c's row-mask argument. NULL enables all anchors. */
    const uint16_t *row_anchor_masks;
    void (*placement)(void *, const MavenBoardPlacement *, const uint8_t remaining[128]);
    void *user;
} MavenBoardEnumeration;

/* Nonempty-board placement traversal recovered from CODE37+0x7b6/0x98c and
 * recursive left-part/extend-right routines [0x1356,0x14e4). Valid paired board,
 * zero sentinels, <=16 ASCII pool tiles, ascending acyclic dictionaries required.
 * A placement may use more than7 pool tiles; CODE36 rejects it downstream.
 * Emits before CODE37+0xe46 evaluation: no cross-section duplicate suppression,
 * move scoring or ranking. Preserves row/anchor/section/trie traversal order.
 * Rows1..30 are the playable orientations; original row0 scratch setup is not
 * modeled. Scoring prefix tables are omitted because this API only emits
 * placements. Remaining counts and input board are unchanged on return.
 * Static recovery: runtime acceptance is tracked separately. */
void maven_enumerate_board_placements(MavenBoardEnumeration *state);
/* Structured equivalent of the original nonlocal early-exit callback.
 * Stop is checked after placements and while unwinding traversal; rack counts
 * are restored before return. NULL runs the complete enumeration. */
void maven_enumerate_board_placements_until(MavenBoardEnumeration *state, int (*stop)(void *),
                                            void *stop_user);
/* Original shared query buffer: two lexicon sections may emit52 letters and
 * a NUL. Bytes32..63 alias the row scoring flags. The observer runs after a
 * row's cross checks, before its placements, to freeze that row's controls.
 * Buffer must retain prior contents between calls; NULL preserves legacy
 * isolated-query behavior. Does not change the public state structure ABI. */
void maven_enumerate_board_placements_shared(MavenBoardEnumeration *,uint8_t workspace[64],
    void (*row_ready)(void *,unsigned),void *row_user,int (*stop)(void *),void *stop_user);
#endif
