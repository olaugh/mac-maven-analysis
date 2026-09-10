#ifndef MAVEN_ENDGAME_TREE_H
#define MAVEN_ENDGAME_TREE_H
#include <stddef.h>
#include <stdint.h>

typedef struct {
    int16_t lower, upper;
    uint16_t first_child, next_sibling, reserved_word;
    int16_t move_score;
    uint32_t position_hash;
    uint8_t placed_tiles[8];
    uint8_t adjustment_tag, kept_mask, row, column, emptied_rack, leave_tag;
    uint8_t mark, reserved_byte;
} MavenEndgameNode;
typedef struct {
    MavenEndgameNode *nodes;
    uint16_t capacity, free_head, current;
    void (*diagnostic)(void *);
    void (*poll)(void *);
    void *user;
} MavenEndgameTree;

/* CODE30 node pool/tree primitives. Native fields replace BE memory overlays;
 * indices preserve original32-byte-node links, root0 and null child0.
 * Valid acyclic sibling chains, node bounds and capacity2..32767 required.
 * A shared child DAG is permitted; mark bits break recursive revisits.
 * Full solver orchestration and CODE45 leaf evaluation remain separate. */
void maven_endgame_tree_reset(MavenEndgameTree *tree);
uint16_t maven_endgame_allocate_node(MavenEndgameTree *tree);
void maven_endgame_prepend_child(MavenEndgameTree *tree, uint16_t parent, uint16_t child);
void maven_endgame_recompute_bounds(MavenEndgameTree *tree, uint16_t node);
uint16_t maven_endgame_select_child(const MavenEndgameTree *tree, uint16_t node);
void maven_endgame_prune(MavenEndgameTree *tree, uint16_t node);
void maven_endgame_mark(MavenEndgameTree *tree, uint16_t node, uint8_t mark);
void maven_endgame_sweep(MavenEndgameTree *tree);
/* CODE30[0x72e,0x7a4): UINT16_MAX means not found; index0 may match root. */
uint16_t maven_endgame_find_hash(const MavenEndgameTree *tree, uint16_t node, uint32_t hash,
                                 int16_t consecutive_passes);
/* CODE30[0xc22,0xcd2): add a compact node from a full move, preserving byte
 * tags copied from the low bytes of its leave/adjustment terms. Bounds are
 * signed32 arguments narrowed to original words. Returns0 if pool exhausted. */
uint16_t maven_endgame_add_move(MavenEndgameTree *tree, const uint8_t move[34],
                                const uint8_t board[544], int32_t upper, int32_t lower);
/* CODE30[0x7a4,0x7f2): prepend pass with negated parent bounds. */
uint16_t maven_endgame_add_pass(MavenEndgameTree *tree);
/* CODE30[0x7fc,0x8be) sharing phase, with caller-computed position hash.
 * UINT16_MAX means no reusable solved/expanded match. */
uint16_t maven_endgame_reuse_position(MavenEndgameTree *tree, uint32_t hash);
/* CODE30[0xcd2,0xd66): expand placed tiles through the current occupied row;
 * writes through NUL but preserves later bytes, as the executable does. */
void maven_endgame_expand_move(uint8_t move[34], const MavenEndgameNode *node,
                               const uint8_t board[544]);
/* CODE53[0x36,0x6e), supplied nonzero-initialized16-word random table. */
uint32_t maven_hash_bytes(const uint8_t *data, size_t size, const uint32_t table[16]);
uint32_t maven_endgame_position_hash(const uint8_t board[544], const uint8_t *rack,
                                     const uint8_t *other_rack, const uint32_t table[16]);
typedef struct {
    uint16_t optimistic, alternative, guaranteed, next_frontier;
} MavenEndgameFrontier;
/* CODE30[0x34c,0x40e): compare root children by optimistic and guaranteed
 * spread. Repeatedly selecting the same best-guaranteed frontier switches to
 * its strongest alternative, so an exact port must preserve this history. */
MavenEndgameFrontier maven_endgame_choose_frontier(const MavenEndgameTree *tree,
                                                   uint16_t previous_frontier);
/* CODE30[0x45a,0x4c4): word-sized allocation reserve, clock budget and root
 * bound overlap control further expansion. initial_allocation is latched on
 * the first iteration by the orchestration layer. */
int maven_endgame_continue_search(const MavenEndgameTree *tree,
                                  const MavenEndgameFrontier *frontier, int16_t initial_allocation,
                                  int16_t current_allocation, int32_t elapsed, int32_t budget);
#endif
