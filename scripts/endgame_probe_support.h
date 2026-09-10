/* Shared native fixture reader: explicitly decodes guest big-endian fields. */
#include "endgame_leaf.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef struct {
    uint8_t board[544], counts[128], undo[33], row_flags[32];
    uint16_t values[544];
    MavenApplyState app;
    MavenEndgameGeneration generation;
    MavenEndgameTree tree;
    MavenEndgameLeaf leaf;
    MavenEndgameNode nodes[8192];
} Snapshot;
static uint16_t letter_values[128];
static uint8_t word_multipliers[544], letter_multipliers[544], letter_class[128], alphabet[28];
static uint32_t bits[32], hash_table[16], bonus;
static MavenDictionarySection sections[17];
static FILE *fixture;
static Snapshot active, expected[6];
static unsigned call_index, capacity;
static int diagnostics;
static void bytes(void *p, size_t n) {
    if (fread(p, 1, n, fixture) != n) {
        fputs("fixture ended early\n", stderr);
        exit(2);
    }
}
static uint16_t word(void) {
    uint8_t p[2];
    bytes(p, 2);
    return (uint16_t)((uint16_t)p[0] << 8 | p[1]);
}
static int16_t sw(uint16_t x) { return x < 32768 ? (int16_t)x : (int16_t)((int32_t)x - 65536); }
static uint32_t number(void) {
    uint8_t p[4];
    bytes(p, 4);
    return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3];
}
static void words(uint16_t *p, size_t n) {
    while (n--)
        *p++ = word();
}
static void numbers(uint32_t *p, size_t n) {
    while (n--)
        *p++ = number();
}
static void diagnostic(void *u) {
    (void)u;
    ++diagnostics;
}
static void node(MavenEndgameNode *n) {
    n->lower = sw(word());
    n->upper = sw(word());
    n->first_child = word();
    n->next_sibling = word();
    n->reserved_word = word();
    n->move_score = sw(word());
    n->position_hash = number();
    bytes(n->placed_tiles, 8);
    n->adjustment_tag = (uint8_t)fgetc(fixture);
    n->kept_mask = (uint8_t)fgetc(fixture);
    n->row = (uint8_t)fgetc(fixture);
    n->column = (uint8_t)fgetc(fixture);
    n->emptied_rack = (uint8_t)fgetc(fixture);
    n->leave_tag = (uint8_t)fgetc(fixture);
    n->mark = (uint8_t)fgetc(fixture);
    n->reserved_byte = (uint8_t)fgetc(fixture);
}
static void load(Snapshot *s) {
    MavenEndgameGeneration *g = &s->generation;
    unsigned i, j, k, n;
    memset(s, 0, sizeof *s);
    bytes(s->board, 544);
    words(s->values, 544);
    bytes(s->counts, 128);
    bytes(s->undo, 33);
    bytes(g->sorted_rack, 8);
    words(g->canonical_masks, 128);
    words(g->tile_points, 128);
    words(&g->occurrence_masks[0][0], 1024);
    numbers(g->cache.best, 128);
    numbers(g->cache.second, 128);
    bytes(s->row_flags, 32);
    numbers(s->leaf.upper_scores, 10);
    numbers(s->leaf.lower_scores, 10);
    bytes(s->leaf.best_empty_move, 34);
    s->app.new_tiles = sw(word());
    s->app.row_zero_count = sw(word());
    for (i = 0; i < 2; ++i)
        s->app.recorded_row[i] = sw(word());
    for (i = 0; i < 2; ++i)
        s->app.recorded_column[i] = sw(word());
    g->mask_count = word();
    bytes(g->ranking.moves, 340);
    g->ranking.count = word();
    g->ranking.cutoff_bits = number();
    for (i = 0; i < 2; ++i)
        for (j = 0; j < 3; ++j)
            for (k = 0; k < 128; ++k)
                words(g->tables[i][j][k], 9);
    for (i = 0; i < capacity; ++i)
        node(&s->nodes[i]);
    s->tree.free_head = word();
    s->tree.current = word();
    s->leaf.propagation_correction = (int32_t)number();
    s->leaf.propagation_mask = word();
    numbers(&g->conflicts[0][0], 8 * 544);
    n = word();
    g->cache.summary_count = (uint16_t)n;
    g->cache.first = n ? 0 : -1;
    for (i = 0; i < n; ++i) {
        MavenReplySummary *r = &g->cache.replies[i];
        r->next = i + 1 < n ? (int16_t)(i + 1) : -1;
        r->score_bits = number();
        r->emptied_rack = (uint8_t)fgetc(fixture);
        r->kept_mask = (uint8_t)fgetc(fixture);
        r->row = (uint8_t)fgetc(fixture);
        r->column = (uint8_t)fgetc(fixture);
        r->length = (uint8_t)fgetc(fixture);
        r->identifier = (uint8_t)fgetc(fixture);
    }
    s->app.placement = (MavenLetterPlacement){
        s->board, s->values, s->counts, letter_values, word_multipliers, s->undo, diagnostic, NULL};
    s->app.letter_multipliers = letter_multipliers;
    s->app.letter_class = letter_class;
    s->app.alphabet = alphabet;
    g->application = &s->app;
    g->sections = sections;
    g->bingo_bonus = bonus;
    g->bit_masks = bits;
    g->row_flags = s->row_flags;
    s->tree.nodes = s->nodes;
    s->tree.capacity = (uint16_t)capacity;
    s->tree.diagnostic = diagnostic;
    s->leaf.generation = g;
    s->leaf.tree = &s->tree;
    s->leaf.hash_table = hash_table;
}
static void fail(const char *phase, const char *name, size_t index, long long a, long long b) {
    fprintf(stderr, "call %u %s %s[%lu]: %lld != %lld\n", call_index, phase, name,
            (unsigned long)index, a, b);
    exit(1);
}
static void equal(const char *phase, const char *name, const void *a, const void *b, size_t n) {
    const uint8_t *x = a, *y = b;
    size_t i;
    for (i = 0; i < n; ++i)
        if (x[i] != y[i])
            fail(phase, name, i, x[i], y[i]);
}
#define EQ(field) equal(phase, #field, &a->field, &b->field, sizeof a->field)
static void compare(Snapshot *a, Snapshot *b, const char *phase) {
    unsigned i;
    int16_t x, y;
    EQ(nodes);
    EQ(tree.free_head);
    EQ(tree.current);
    EQ(board);
    EQ(values);
    EQ(counts);
    EQ(undo);
    EQ(row_flags);
    EQ(app.row_zero_count);
    EQ(app.new_tiles);
    EQ(app.recorded_row);
    EQ(app.recorded_column);
    EQ(generation.sorted_rack);
    EQ(generation.canonical_masks);
    EQ(generation.tile_points);
    EQ(generation.occurrence_masks);
    EQ(generation.mask_count);
    EQ(generation.tables);
    EQ(generation.cache.best);
    EQ(generation.cache.second);
    EQ(generation.conflicts);
    EQ(generation.ranking.count);
    EQ(generation.ranking.cutoff_bits);
    /* CODE29 uses ranking and best-move storage as scratch. Their UI-record
     * bytes are deliberately outside this leaf API's observable outputs. */
    x = a->generation.cache.first;
    y = b->generation.cache.first;
    i = 0;
    while (x >= 0 && y >= 0) {
        MavenReplySummary *r = &a->generation.cache.replies[x],
                          *s = &b->generation.cache.replies[y];
        equal(phase, "reply score", &r->score_bits, &s->score_bits, 4);
        equal(phase, "reply fields", &r->emptied_rack, &s->emptied_rack, 6);
        x = r->next;
        y = s->next;
        if (++i > 266)
            fail(phase, "reply loop", i, x, y);
    }
    if (x >= 0 || y >= 0)
        fail(phase, "reply list length", i, x, y);
}
