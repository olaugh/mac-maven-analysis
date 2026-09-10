#include "endgame_leaf.h"
#include "board_state.h"
#include "rack_counts.h"
#include "rack_masks.h"
#include <string.h>
static int16_t word(uint16_t x) { return x < 32768 ? (int16_t)x : (int16_t)((int32_t)x - 65536); }
static int32_t signed_long(uint32_t x) {
    return x <= INT32_MAX ? (int32_t)x : (int32_t)((int64_t)x - INT64_C(4294967296));
}
static uint32_t read_long(const uint8_t *p) {
    return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3];
}
static void write_long(uint8_t *p, uint32_t x) {
    p[0] = (uint8_t)(x >> 24);
    p[1] = (uint8_t)(x >> 16);
    p[2] = (uint8_t)(x >> 8);
    p[3] = (uint8_t)x;
}
static void diagnostic(MavenEndgameLeaf *s) {
    if (s->tree->diagnostic)
        s->tree->diagnostic(s->tree->user);
}
static void poll(MavenEndgameLeaf *s) {
    if (s->tree->poll)
        s->tree->poll(s->tree->user);
}
static void checkpoint(MavenEndgameLeaf *s, const char *phase) {
    if (s->checkpoint)
        s->checkpoint(s->user, phase);
}
static int16_t rack_points(MavenEndgameLeaf *s, const uint8_t *rack) {
    uint16_t total = 0;
    const uint16_t *points = s->generation->application->placement.letter_values;
    while (*rack)
        total = (uint16_t)(total + points[*rack++]);
    return word(total);
}
static int current_is_pass(const MavenEndgameTree *tree) {
    return tree->current && !tree->nodes[tree->current].row;
}
static void prepare_masks(MavenEndgameLeaf *s, const uint8_t *rack) {
    MavenEndgameGeneration *g = s->generation;
    MavenApplyState *a = g->application;
    maven_count_rack(a->placement.counts, a->alphabet, rack);
    maven_rack_from_counts(g->sorted_rack, a->placement.counts, a->alphabet);
    g->mask_count =
        maven_prepare_canonical_rack_masks(g->sorted_rack, a->placement.letter_values,
                                           g->canonical_masks, g->tile_points, g->occurrence_masks);
}
static void bind_bounds(MavenEndgameLeaf *s) {
    MavenEndgameGeneration *g = s->generation;
    s->rack_bounds = (MavenEndgameRackBounds){g->tables[0][0], g->tables[0][1], g->tables[0][2],
                                              g->tables[1][0], g->tables[1][1], g->tables[1][2]};
    s->reply_conflicts.board = g->application->placement.board;
    s->reply_conflicts.cell_conflicts = g->conflicts;
    s->reply_conflicts.bit_masks = g->bit_masks;
    s->reply_bounds = (MavenReplyBounds){&g->cache,
                                         &s->reply_conflicts,
                                         g->tile_points,
                                         maven_bound_paired_racks,
                                         maven_bound_own_rack,
                                         &s->rack_bounds};
}
static void insert_bound(uint32_t values[10], unsigned position, unsigned count, uint32_t value) {
    if (position >= 10)
        return;
    memmove(values + position + 1, values + position, (count - 1 - position) * sizeof *values);
    values[position] = value;
}
void maven_endgame_bound_candidate(MavenEndgameLeaf *s, uint8_t move[34]) {
    MavenEndgameGeneration *g = s->generation;
    MavenApplyState *a = g->application;
    uint32_t upper = s->upper_scores[9], lower = s->lower_scores[9];
    int16_t empty, compatible;
    unsigned ui = 0, li = 0;
    uint32_t score = read_long(move + 16);
    if (!maven_candidate_is_eligible(move, a->placement.board, a->new_tiles, NULL, NULL))
        return;
    if (move[28] || move[29]) {
        if (signed_long(score) > signed_long(read_long(s->best_empty_move + 16)))
            memcpy(s->best_empty_move, move, 34);
        return;
    }
    if (maven_bound_move_against_replies(&s->reply_bounds, move, &upper, &lower, &empty,
                                         &compatible))
        return;
    while (ui < g->ranking.count && signed_long(upper) <= signed_long(s->upper_scores[ui]))
        ++ui;
    while (li < g->ranking.count && signed_long(lower) <= signed_long(s->lower_scores[li]))
        ++li;
    if (g->ranking.count < 10)
        ++g->ranking.count;
    insert_bound(s->upper_scores, ui, g->ranking.count, upper);
    insert_bound(s->lower_scores, li, g->ranking.count, lower);
    if (!move[32]) {
        int32_t terminal = rack_points(s, s->other_rack) - rack_points(s, s->own_rack);
        terminal = word((uint16_t)terminal);
        if (terminal < signed_long(lower))
            lower = (uint32_t)terminal;
        if (terminal < signed_long(upper))
            upper = (uint32_t)terminal;
    } else {
        upper -= score;
        lower -= score;
    }
    write_long(move + 20, (uint32_t)(int32_t)empty);
    write_long(move + 24, (uint32_t)(int32_t)compatible);
    maven_endgame_add_move(s->tree, move, a->placement.board, signed_long(0u - lower),
                           signed_long(0u - upper));
}
static void count_move_tiles(MavenEndgameLeaf *s, const uint8_t move[34]) {
    MavenApplyState *a = s->generation->application;
    a->new_tiles = maven_count_new_move_tiles(move, a->placement.board);
}

typedef struct {
    MavenEndgameLeaf *leaf;
    MavenScoreScan score;
} AllContext;
static void all_candidate(void *user, const uint8_t raw[34]) {
    AllContext *c = user;
    MavenApplyState *a = c->leaf->generation->application;
    uint8_t move[34];
    a->new_tiles = c->score.new_tiles;
    memcpy(move, raw, 34);
    maven_endgame_bound_candidate(c->leaf, move);
}
static void generate_all(MavenEndgameLeaf *s,uint8_t *workspace) {
    MavenEndgameGeneration *g = s->generation;
    MavenApplyState *a = g->application;
    MavenLetterPlacement *p = &a->placement;
    uint16_t leave[128] = {0};
    MavenBoardMoves m = {0};
    AllContext c = {0};
    c.leaf = s;
    m.enumeration.sections = g->sections;
    m.enumeration.board = p->board;
    m.enumeration.letter_multipliers = a->letter_multipliers;
    m.enumeration.word_multipliers = p->premium_codes;
    memcpy(m.enumeration.remaining, p->counts, 128);
    m.scoring = (MavenScoreInput){
        p->board,        p->values,   p->letter_values, p->premium_codes, a->letter_multipliers,
        a->letter_class, a->alphabet, p->diagnostic,    p->user};
    m.sorted_rack = g->sorted_rack;
    m.leave_values = leave;
    m.move = all_candidate;
    m.user = &c;
    if(workspace)maven_generate_board_moves_shared(&m,g->bingo_bonus,&c.score,workspace,g->occurrence_masks,0);
    else maven_generate_board_moves_prepared(&m, g->bingo_bonus, &c.score, g->row_flags,
                                        g->occurrence_masks);
}
static void local_replies(MavenEndgameLeaf *s, MavenEndgameNode *node, uint8_t *rack,
                          const uint8_t *reply, void (*candidate)(void *, const uint8_t *),
                          void *user,uint8_t *workspace) {
    MavenEndgameGeneration *g = s->generation;
    MavenLocalReplies local = {0};
    uint8_t move[34];
    uint16_t leave[128] = {0};
    maven_endgame_expand_move(move, node, g->application->placement.board);
    local.application = g->application;
    local.sections = g->sections;
    local.bit_masks = g->bit_masks;
    local.leave_values = leave;
    local.bingo_bonus = g->bingo_bonus;
    local.row_flags = g->row_flags;
    memcpy(local.sorted_rack, g->sorted_rack, 8);
    local.candidate = candidate;
    local.user = user;
    maven_generate_local_replies_shared(&local,move,rack,reply,local.sorted_rack,NULL,0,workspace);
}
typedef struct {
    MavenEndgameLeaf *s;
    MavenEndgameNode *node;
    int32_t upper, lower;
    uint16_t best_empty;
    int any;
} TightenContext;
static void bound_local_reply(void *user, const uint8_t move[34]) {
    TightenContext *c = user;
    uint32_t upper, lower;
    int16_t positive, negative;
    uint16_t empty = (uint16_t)((uint16_t)move[28] << 8 | move[29]);
    uint32_t score = read_long(move + 16);
    c->any = 1;
    if (empty)
        upper = lower =
            score + (uint32_t)(int32_t)word((uint16_t)(2 * rack_points(c->s, c->s->own_rack)));
    else {
        int16_t value = maven_bound_paired_racks(&c->s->rack_bounds, c->node->kept_mask,
                                                 (int16_t)((uint16_t)move[30] << 8 | move[31]),
                                                 &positive, &negative);
        uint32_t base = score - (uint32_t)(int32_t)value;
        upper = base + (uint32_t)(int32_t)negative;
        lower = base - (uint32_t)(int32_t)positive;
        if (signed_long(lower) > signed_long(upper))
            diagnostic(c->s);
    }
    if (signed_long(upper) > c->upper) {
        c->upper = signed_long(upper);
        c->best_empty = empty;
    }
    if (signed_long(lower) > c->lower) {
        c->lower = signed_long(lower);
        c->best_empty = empty;
    }
}
static void tighten_replies(MavenEndgameLeaf *s,uint8_t *workspace) {
    uint16_t child;
    prepare_masks(s, s->other_rack);
    for (child = s->tree->nodes[s->tree->current].first_child; child;
         child = s->tree->nodes[child].next_sibling) {
        MavenEndgameNode *node = &s->tree->nodes[child];
        TightenContext c = {s, node, node->upper, node->lower, 0, 0};
        if (node->emptied_rack || node->first_child || !node->row)
            continue;
        /* CODE29+0070 clears A5-5a32 before tightening each eligible node.
         * This is the same storage as the leaf best-empty record and the
         * final ranking expansion scratch; preserve its stale-byte lifecycle. */
        memset(s->best_empty_move, 0, sizeof s->best_empty_move);
        local_replies(s, node, s->own_rack, s->other_rack, bound_local_reply, &c,workspace);
        write_long(s->best_empty_move + 24, c.any ? 1u : 0u);
        s->best_empty_move[28] = (uint8_t)(c.best_empty >> 8);
        s->best_empty_move[29] = (uint8_t)c.best_empty;
        node->upper = word((uint16_t)c.upper);
        node->lower = word((uint16_t)c.lower);
        if (c.best_empty)
            node->leave_tag = 1;
        if (c.any)
            node->adjustment_tag = 1;
    }
}
static void best_local_score(void *user, const uint8_t move[34]) {
    MavenEndgameLeaf *s = user;
    unsigned mask = (unsigned)move[30] << 8 | move[31];
    uint32_t score = read_long(move + 16);
    if (signed_long(score) > signed_long(s->generation->cache.best[mask]))
        s->generation->cache.best[mask] = score;
}
static void tighten_continuations(MavenEndgameLeaf *s,uint8_t *workspace) {
    uint16_t child;
    MavenEndgameGeneration *g = s->generation;
    prepare_masks(s, s->own_rack);
    for (child = s->tree->nodes[s->tree->current].first_child; child;
         child = s->tree->nodes[child].next_sibling) {
        MavenEndgameNode *node = &s->tree->nodes[child];
        int32_t correction;
        uint16_t sibling;
        if (node->emptied_rack || node->leave_tag || node->first_child || !node->row)
            continue;
        memset(g->cache.best, 0, sizeof g->cache.best);
        local_replies(s, node, s->own_rack, s->own_rack, best_local_score, s,workspace);
        maven_endgame_local_score_corrections(
            &s->rack_bounds, node->kept_mask, node->move_score, g->sorted_rack, g->canonical_masks,
            g->mask_count, g->cache.best, node->adjustment_tag ? 1 : 8,
            node->adjustment_tag ? 2 : 8, &correction, &s->propagation_correction,
            &s->propagation_mask, s->tree->diagnostic, s->tree->user);
        node->lower = word((uint16_t)((uint16_t)node->lower - (uint16_t)correction));
        if (!s->propagation_correction)
            continue;
        for (sibling = s->tree->nodes[s->tree->current].first_child; sibling;
             sibling = s->tree->nodes[sibling].next_sibling) {
            MavenEndgameNode *n = &s->tree->nodes[sibling];
            if (word(n->reserved_word) < s->propagation_correction && !n->emptied_rack &&
                !n->leave_tag && !n->first_child &&
                ((n->kept_mask | s->propagation_mask) == n->kept_mask))
                n->reserved_word = (uint16_t)s->propagation_correction;
        }
    }
}
void maven_endgame_finish_child(MavenEndgameLeaf *s, uint16_t index) {
    MavenEndgameNode *n = &s->tree->nodes[index];
    poll(s);
    n->lower = word((uint16_t)((uint16_t)n->lower - n->reserved_word));
    n->reserved_word = 0;
    if (!n->adjustment_tag && n->leave_tag)
        diagnostic(s);
    if (!n->row && current_is_pass(s->tree))
        n->lower = n->upper =
            word((uint16_t)(rack_points(s, s->own_rack) - rack_points(s, s->other_rack)));
    else if (!n->emptied_rack && !n->adjustment_tag && !n->first_child) {
        if (!n->row)
            n->lower = n->upper =
                word((uint16_t)(rack_points(s, s->own_rack) - rack_points(s, s->other_rack)));
        else {
            uint16_t child = maven_endgame_allocate_node(s->tree);
            if (child) {
                MavenEndgameNode *pass = &s->tree->nodes[child];
                pass->kept_mask = 127;
                maven_endgame_prepend_child(s->tree, index, child);
                pass->lower = word((uint16_t)(-n->upper));
                pass->upper = word((uint16_t)(-n->lower));
            }
        }
    }
}
int maven_expand_endgame_leaf_shared(MavenEndgameLeaf *s,uint8_t workspace[64]) {
    MavenEndgameGeneration *g = s->generation;
    uint8_t moves[10][34], pass[34] = {0};
    unsigned count, i;
    uint16_t child;
    uint32_t hash = maven_endgame_position_hash(g->application->placement.board, s->own_rack,
                                                s->other_rack, s->hash_table);
    poll(s);
    if (maven_endgame_reuse_position(s->tree, hash) != UINT16_MAX)
        return 1;
    count = maven_prepare_endgame_candidates_shared(g, s->own_rack, s->other_rack, moves,workspace);
    checkpoint(s, "generation");
    if (!count) {
        if (current_is_pass(s->tree)) {
            int16_t terminal =
                word((uint16_t)(rack_points(s, s->own_rack) - rack_points(s, s->other_rack)));
            pass[31] = 127;
            maven_endgame_add_move(s->tree, pass, g->application->placement.board, terminal,
                                   terminal);
        } else
            maven_endgame_add_pass(s->tree);
        return 0;
    }
    maven_prepare_endgame_rack(g, s->own_rack);
    bind_bounds(s);
    for (i = 0; i < 10; ++i)
        s->upper_scores[i] = s->lower_scores[i] = UINT32_C(0xf4143e00);
    memset(s->best_empty_move, 0, 34);
    for (i = 0; i < count; ++i) {
        count_move_tiles(s, moves[i]);
        maven_endgame_bound_candidate(s, moves[i]);
    }
    if (count == 10) {
        s->tree->nodes[s->tree->current].first_child = 0;
        generate_all(s,workspace);
    }
    pass[31] = 127;
    maven_endgame_bound_candidate(s, pass);
    if (s->best_empty_move[28] || s->best_empty_move[29]) {
        int32_t bound = -word((uint16_t)(2 * rack_points(s, s->other_rack)));
        write_long(s->best_empty_move + 20, 0);
        write_long(s->best_empty_move + 24, 1);
        maven_endgame_add_move(s->tree, s->best_empty_move, g->application->placement.board, bound,
                               bound);
    }
    checkpoint(s, "candidates");
    tighten_replies(s,workspace);
    checkpoint(s, "replies");
    tighten_continuations(s,workspace);
    checkpoint(s, "continuations");
    for (child = s->tree->nodes[s->tree->current].first_child; child;
         child = s->tree->nodes[child].next_sibling)
        maven_endgame_finish_child(s, child);
    checkpoint(s, "finished");
    return 0;
}

void maven_endgame_tighten_replies(MavenEndgameLeaf *s){tighten_replies(s,NULL);}
void maven_endgame_tighten_continuations(MavenEndgameLeaf *s){tighten_continuations(s,NULL);}
int maven_expand_endgame_leaf(MavenEndgameLeaf *s){return maven_expand_endgame_leaf_shared(s,NULL);}
