#include "endgame_search.h"
#include "board_state.h"
#include "rack_counts.h"
#include "rack_masks.h"
#include <string.h>
static int16_t word(uint16_t x) { return x < 32768 ? (int16_t)x : (int16_t)((int32_t)x - 65536); }
static void write_long(uint8_t *p, uint32_t x) {
    p[0] = (uint8_t)(x >> 24);
    p[1] = (uint8_t)(x >> 16);
    p[2] = (uint8_t)(x >> 8);
    p[3] = (uint8_t)x;
}
static void diagnostic(MavenEndgameSearch *s) {
    MavenEndgameTree *t = s->leaf.tree;
    if (t->diagnostic)
        t->diagnostic(t->user);
}
static void checkpoint(MavenEndgameSearch *s, const char *phase) {
    if (s->checkpoint)
        s->checkpoint(s->user, phase);
}
static void scale(MavenEndgameSearch *s, int direction) {
    MavenEndgameGeneration *g = s->leaf.generation;
    uint16_t *values = g->application->placement.values;
    unsigned i;
    for (i = 0; i < 544; ++i)
        values[i] =
            direction < 0 ? (uint16_t)(word(values[i]) / 100) : (uint16_t)(100 * word(values[i]));
    for (i = 0; i < 128; ++i)
        s->letter_values[i] = direction < 0 ? (uint16_t)(word(s->letter_values[i]) / 100)
                                            : (uint16_t)(100 * word(s->letter_values[i]));
    g->bingo_bonus =
        direction < 0 ? (uint32_t)(int32_t)(word((uint16_t)g->bingo_bonus) / 100)
                      : (uint32_t)(int32_t)word((uint16_t)(100 * word((uint16_t)g->bingo_bonus)));
}
static void prepare_masks(MavenEndgameSearch *s, const uint8_t *rack) {
    MavenEndgameGeneration *g = s->leaf.generation;
    MavenApplyState *a = g->application;
    maven_count_rack(a->placement.counts, a->alphabet, rack);
    maven_rack_from_counts(g->sorted_rack, a->placement.counts, a->alphabet);
    g->mask_count = maven_prepare_canonical_rack_masks(
        g->sorted_rack, s->letter_values, g->canonical_masks, g->tile_points, g->occurrence_masks);
}
typedef struct {
    MavenEndgameSearch *s;
    int found;
} AnyMove;
static void first_placement(void *user, const MavenBoardPlacement *p, const uint8_t *remaining) {
    AnyMove *c = user;
    MavenEndgameGeneration *g = c->s->leaf.generation;
    uint8_t move[34] = {0};
    (void)remaining;
    if (maven_counted_sections_contain(g->sections, p->section, p->word))
        return;
    memcpy(move, p->word, 16);
    move[32] = p->row;
    move[33] = p->column;
    g->application->new_tiles = maven_count_new_move_tiles(move, g->application->placement.board);
    c->found = 1;
}
static int stop_at_first(void *user) { return ((AnyMove *)user)->found; }
static int any_move(MavenEndgameSearch *s,uint8_t *workspace) {
    MavenEndgameGeneration *g = s->leaf.generation;
    MavenApplyState *a = g->application;
    MavenBoardEnumeration e = {0};
    AnyMove context = {s, 0};
    e.sections = g->sections;
    e.board = a->placement.board;
    e.letter_multipliers = a->letter_multipliers;
    e.word_multipliers = a->placement.premium_codes;
    memcpy(e.remaining, a->placement.counts, 128);
    e.placement = first_placement;
    e.user = &context;
    maven_enumerate_board_placements_shared(&e,workspace,NULL,NULL,stop_at_first,&context);
    return context.found;
}
static int16_t rack_points(MavenEndgameSearch *s, const uint8_t *rack) {
    uint16_t n = 0;
    while (*rack)
        n = (uint16_t)(n + s->letter_values[*rack++]);
    return word(n);
}
static int eligible(void *user, const uint8_t *move) {
    MavenApplyState *a = user;
    return maven_candidate_is_eligible(move, a->placement.board, a->new_tiles, NULL, NULL);
}
unsigned maven_search_endgame_shared(MavenEndgameSearch *s,uint8_t workspace[64]) {
    MavenEndgameGeneration *g = s->leaf.generation;
    MavenEndgameTree *tree = s->leaf.tree;
    MavenApplyState *a = g->application;
    uint8_t saved_move[34], saved_board[544], saved_own[8], saved_other[8], move[34], kept[8];
    uint16_t saved_values[544];
    uint8_t *own = s->own_rack, *other = s->other_rack;
    int16_t saved_passes;
    uint16_t child, last;
    unsigned depth;
    s->was_cancelled = 0;
    if (s->cancel_requested && s->cancel_requested(s->user)) {
        s->was_cancelled = 1;
        return 0;
    }
    memcpy(saved_move, s->selected_move, 34);
    s->initial_reserve = 0;
    s->iterations = 0;
    s->next_frontier = 0;
    memset(g->ranking.moves, 0, sizeof g->ranking.moves);
    maven_prepare_endgame_rack(g, own);
    g->ranking.moves[0][31] = 127;
    if (!any_move(s,workspace)) {
        g->ranking.count = 1;
        checkpoint(s, "finished");
        return 1;
    }
    scale(s, -1);
    maven_endgame_tree_reset(tree);
    memset(s->leave_values, 0, sizeof s->leave_values);
    maven_count_rack(a->placement.counts, a->alphabet, other);
    maven_rack_from_counts(other, a->placement.counts, a->alphabet);
    maven_count_rack(a->placement.counts, a->alphabet, own);
    maven_rack_from_counts(own, a->placement.counts, a->alphabet);
    memcpy(saved_board, a->placement.board, 544);
    memcpy(saved_values, a->placement.values, sizeof saved_values);
    saved_passes = a->row_zero_count;
    strcpy((char *)saved_own, (const char *)own);
    strcpy((char *)saved_other, (const char *)other);
    do {
        int32_t elapsed;
        uint16_t previous = s->next_frontier;
        tree->current = previous;
        last = previous;
        depth = 0;
        while (tree->current) {
            ++depth;
            if (depth >= 200) {
                diagnostic(s);
                break;
            }
            last = tree->current;
            prepare_masks(s, own);
            maven_endgame_expand_move(move, &tree->nodes[tree->current], a->placement.board);
            maven_apply_move_with_bonus(move, own, a, g->bingo_bonus);
            maven_rack_from_mask(kept, g->sorted_rack, g->bit_masks,
                                 (int16_t)((uint16_t)move[30] << 8 | move[31]),
                                 (const int16_t *)g->canonical_masks, (int16_t)g->mask_count,
                                 tree->diagnostic, tree->user);
            strcpy((char *)own, (const char *)kept);
            {
                uint8_t *swap = own;
                own = other;
                other = swap;
            }
            tree->current = maven_endgame_select_child(tree, tree->current);
        }
        if (!previous) {
            tree->current = maven_endgame_select_child(tree, 0);
            if (tree->current) {
                diagnostic(s);
            }
            last = 0;
        }
        tree->current = last;
        s->leaf.own_rack = own;
        s->leaf.other_rack = other;
        checkpoint(s, "leaf_entry");
        maven_expand_endgame_leaf_shared(&s->leaf,workspace);
        maven_endgame_recompute_bounds(tree, 0);
        s->frontier = maven_endgame_choose_frontier(tree, previous);
        s->next_frontier = s->frontier.next_frontier;
        memcpy(a->placement.board, saved_board, 544);
        memcpy(a->placement.values, saved_values, sizeof saved_values);
        own = s->own_rack;
        other = s->other_rack;
        strcpy((char *)own, (const char *)saved_own);
        strcpy((char *)other, (const char *)saved_other);
        if (!s->initial_reserve)
            s->initial_reserve = s->reserve_control;
        ++s->iterations;
        checkpoint(s, "iteration");
        if (s->cancel_requested && s->cancel_requested(s->user)) {
            s->was_cancelled = 1;
            break;
        }
        if (word((uint16_t)((uint16_t)s->reserve_control + (uint16_t)s->initial_reserve)) >=
            tree->capacity)
            break;
        elapsed = s->elapsed_seconds ? s->elapsed_seconds(s->user) : 0;
        if (!maven_endgame_continue_search(tree, &s->frontier, s->initial_reserve,
                                           s->reserve_control, elapsed, s->budget_seconds))
            break;
    } while (1);
    checkpoint(s, "ranking");
    /* A5-5a32 is shared with the leaf best-empty scratch record. Node
     * expansion writes only through NUL, so its remaining bytes must come
     * from the last leaf record rather than the saved caller selection. */
    memcpy(s->selected_move, s->leaf.best_empty_move, sizeof s->selected_move);
    maven_prepare_endgame_rack(g, own);
    for (child = tree->nodes[0].first_child; child; child = tree->nodes[child].next_sibling) {
        MavenEndgameNode *node = &tree->nodes[child];
        maven_endgame_expand_move(s->selected_move, node, a->placement.board);
        if (saved_passes && !s->selected_move[32])
            write_long(s->selected_move + 16,
                       (uint32_t)(100 * (int32_t)word((uint16_t)(rack_points(s, other) -
                                                                 rack_points(s, own)))));
        else {
            write_long(s->selected_move + 20,
                       (uint32_t)(int32_t)word((uint16_t)(-100 * (int32_t)node->upper)));
            write_long(s->selected_move + 24, (uint32_t)(int32_t)node->lower);
        }
        a->new_tiles = maven_count_new_move_tiles(s->selected_move, a->placement.board);
        maven_insert_ranked_candidate(&g->ranking, s->selected_move, eligible, a);
    }
    memcpy(s->selected_move, saved_move, 34);
    a->row_zero_count = saved_passes;
    scale(s, 1);
    checkpoint(s, "finished");
    return g->ranking.count;
}

unsigned maven_search_endgame(MavenEndgameSearch *s){return maven_search_endgame_shared(s,NULL);}
