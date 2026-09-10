#ifndef MAVEN_ENDGAME_LEAF_H
#define MAVEN_ENDGAME_LEAF_H
#include "endgame_generation.h"
#include "endgame_tree.h"
#include "local_replies.h"
typedef struct {
    MavenEndgameGeneration *generation;
    MavenEndgameTree *tree;
    const uint32_t *hash_table; /*16 original, already initialized hash words */
    uint8_t *own_rack, *other_rack;
    uint32_t upper_scores[10], lower_scores[10];
    uint8_t best_empty_move[34];
    MavenReplyConflicts reply_conflicts;
    MavenEndgameRackBounds rack_bounds;
    MavenReplyBounds reply_bounds;
    int32_t propagation_correction;
    uint16_t propagation_mask;
    void (*checkpoint)(void *, const char *phase);
    void *user;
} MavenEndgameLeaf;
/* CODE45+4 candidate processing. Input is mutable because accepted bounds
 * become the move's two low-byte node tags. All scores use point units. */
void maven_endgame_bound_candidate(MavenEndgameLeaf *state, uint8_t move[34]);
/* CODE45+1ee: apply propagated correction, settle pass nodes and add a
 * fallback pass child to unexpanded nodes without compatible cached replies. */
void maven_endgame_finish_child(MavenEndgameLeaf *state, uint16_t index);
/* CODE29+2c/+15e tighten existing leaf children with local reply/continuation
 * generation. Kept masks refer to full racks even when continuation uses the
 * reduced rack after its first move. */
void maven_endgame_tighten_replies(MavenEndgameLeaf *state);
void maven_endgame_tighten_continuations(MavenEndgameLeaf *state);
/* CODE45+2b8: hash reuse, two-rack generation, bound-filtered expansion,
 * explicit pass/going-out candidates and two local tightening passes.
 * UI polling uses the tree's supplied poll callback. The hash table must be
 * initialized by the caller, keeping random/clock behavior outside this API.
 * Returns1 on transposition reuse,0 on normal expansion (port convenience). */
int maven_expand_endgame_leaf(MavenEndgameLeaf *state);
int maven_expand_endgame_leaf_shared(MavenEndgameLeaf *,uint8_t workspace[64]);
#endif
