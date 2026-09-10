#ifndef MAVEN_ENDGAME_SEARCH_H
#define MAVEN_ENDGAME_SEARCH_H
#include "endgame_leaf.h"
typedef struct {
    MavenEndgameLeaf leaf;
    uint16_t *letter_values; /* same128 words referenced by application scorer */
    uint8_t *own_rack, *other_rack;
    uint8_t selected_move[34];
    uint16_t leave_values[128];
    int16_t reserve_control, initial_reserve;
    int32_t budget_seconds;
    /* CODE9+86 returns rounded elapsed seconds. Supplying this boundary keeps
     * debugger-time streams reproducible and modern browser scheduling separate. */
    int32_t (*elapsed_seconds)(void *);
    void (*checkpoint)(void *, const char *phase);
    void *user;
    unsigned iterations;
    MavenEndgameFrontier frontier;
    uint16_t next_frontier;
    /* Modern cooperative stop, checked before work and after each restored
     * iteration. Not an emulation of original nonlocal UI cancellation. */
    int (*cancel_requested)(void *);
    int was_cancelled;
} MavenEndgameSearch;
/* CODE30+14e normal completed path. Requires nonempty legal board, writable
 * original point*100 values, original node capacity and initialized hash table.
 * Returns the output candidate count. Poll callbacks must return normally;
 * UI cancellation/nonlocal exception unwinding is not modeled by this API.
 * Node/cache internals stay in point units; board/letter/bingo globals are
 * restored to point*100, as are output move score/leave components. */
unsigned maven_search_endgame(MavenEndgameSearch *state);
unsigned maven_search_endgame_shared(MavenEndgameSearch *,uint8_t workspace[64]);
#endif
