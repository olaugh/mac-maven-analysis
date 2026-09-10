/* Trusted-input research bridge for the recovered endgame. Numeric arrays
 * use wasm little-endian words; move and dictionary records retain BE bytes. */
#include "endgame_search.h"
#include <stddef.h>
#include <string.h>
static uint8_t board[544], counts[128], undo[33], row_flags[32], own[8], other[8];
static uint16_t values[544], letter_values[128];
static uint8_t word_multipliers[544], letter_multipliers[544], letter_class[128], alphabet[28],
    dictionary[1200000];
static uint32_t bit_masks[32], hash_table[16], section_spec[17][2], elapsed_ticks[4096],
    start_ticks, clock_index;
static MavenDictionarySection sections[17];
static MavenApplyState application;
static MavenEndgameGeneration generation;
static MavenEndgameNode nodes[8192];
static MavenEndgameTree tree;
static MavenEndgameSearch search;
static uint32_t poll_calls, empty_pool_polls;
static void polled(void *u) {
    (void)u;
    ++poll_calls;
    if (!tree.free_head)
        ++empty_pool_polls;
}
void *memset(void *p, int c, size_t n) {
    uint8_t *s = p;
    while (n--)
        *s++ = (uint8_t)c;
    return p;
}
void *memcpy(void *to, const void *from, size_t n) {
    uint8_t *d = to;
    const uint8_t *s = from;
    while (n--)
        *d++ = *s++;
    return to;
}
void *memmove(void *to, const void *from, size_t n) {
    uint8_t *d = to;
    const uint8_t *s = from;
    if (d < s)
        while (n--)
            *d++ = *s++;
    else {
        d += n;
        s += n;
        while (n--)
            *--d = *--s;
    }
    return to;
}
int memcmp(const void *a, const void *b, size_t n) {
    const unsigned char *x = a, *y = b;
    while (n--) {
        if (*x != *y)
            return *x - *y;
        ++x;
        ++y;
    }
    return 0;
}
char *strcpy(char *to, const char *from) {
    char *d = to;
    while ((*d++ = *from++)) {
    }
    return to;
}
size_t strlen(const char *p) {
    const char *s = p;
    while (*p)
        ++p;
    return (size_t)(p - s);
}
int strcmp(const char *a, const char *b) {
    while (*a && *a == *b) {
        ++a;
        ++b;
    }
    return (unsigned char)*a - (unsigned char)*b;
}
char *strchr(const char *s, int c) {
    do {
        if ((unsigned char)*s == (unsigned char)c)
            return (char *)s;
    } while (*s++);
    return NULL;
}
static void diagnostic(void *u) {
    (void)u;
    __builtin_trap();
}
static int32_t elapsed(void *u) {
    uint32_t bits;
    int32_t value;
    (void)u;
    if (clock_index >= 4096)
        __builtin_trap();
    bits = elapsed_ticks[clock_index++] - start_ticks + 30;
    value = bits <= INT32_MAX ? (int32_t)bits : (int32_t)((int64_t)bits - INT64_C(4294967296));
    return value / 60;
}
void *maven_endgame_buffer(unsigned id) {
    switch (id) {
    case 0:
        return board;
    case 1:
        return values;
    case 2:
        return letter_values;
    case 3:
        return word_multipliers;
    case 4:
        return letter_multipliers;
    case 5:
        return letter_class;
    case 6:
        return alphabet;
    case 7:
        return own;
    case 8:
        return other;
    case 9:
        return undo;
    case 10:
        return counts;
    case 11:
        return row_flags;
    case 12:
        return hash_table;
    case 13:
        return bit_masks;
    case 14:
        return dictionary;
    case 15:
        return section_spec;
    case 16:
        return generation.sorted_rack;
    case 17:
        return generation.canonical_masks;
    case 18:
        return generation.tile_points;
    case 19:
        return generation.occurrence_masks;
    case 20:
        return generation.cache.best;
    case 21:
        return generation.cache.second;
    case 22:
        return generation.tables;
    case 23:
        return nodes;
    case 24:
        return generation.ranking.moves;
    case 25:
        return search.selected_move;
    case 26:
        return search.leave_values;
    case 27:
        return search.leaf.upper_scores;
    case 28:
        return search.leaf.lower_scores;
    case 29:
        return search.leaf.best_empty_move;
    case 30:
        return generation.conflicts;
    case 31:
        return elapsed_ticks;
    default:
        __builtin_trap();
    }
}
void maven_endgame_initialize(void) {
    unsigned i;
    memset(&generation, 0, sizeof generation);
    memset(&application, 0, sizeof application);
    memset(&tree, 0, sizeof tree);
    memset(&search, 0, sizeof search);
    application.placement = (MavenLetterPlacement){
        board, values, counts, letter_values, word_multipliers, undo, diagnostic, 0};
    application.letter_multipliers = letter_multipliers;
    application.letter_class = letter_class;
    application.alphabet = alphabet;
    for (i = 0; i < 17; ++i) {
        sections[i] = (MavenDictionarySection){dictionary + section_spec[i][0], section_spec[i][1]};
        if (!section_spec[i][1])
            break;
    }
    if (i == 17)
        __builtin_trap();
    generation.application = &application;
    generation.sections = sections;
    generation.bit_masks = bit_masks;
    generation.row_flags = row_flags;
    generation.bingo_bonus = 5000;
    tree.nodes = nodes;
    tree.capacity = 8192;
    tree.diagnostic = diagnostic;
    tree.poll = polled;
    search.leaf.generation = &generation;
    search.leaf.tree = &tree;
    search.leaf.hash_table = hash_table;
    search.letter_values = letter_values;
    search.own_rack = own;
    search.other_rack = other;
    search.elapsed_seconds = elapsed;
    search.budget_seconds = 120;
}
void maven_endgame_set(unsigned id, int32_t value) {
    switch (id) {
    case 0:
        application.row_zero_count = (int16_t)value;
        break;
    case 1:
        application.new_tiles = (int16_t)value;
        break;
    case 2:
        application.recorded_row[0] = (int16_t)value;
        break;
    case 3:
        application.recorded_row[1] = (int16_t)value;
        break;
    case 4:
        application.recorded_column[0] = (int16_t)value;
        break;
    case 5:
        application.recorded_column[1] = (int16_t)value;
        break;
    case 6:
        generation.ranking.cutoff_bits = (uint32_t)value;
        break;
    case 7:
        search.reserve_control = (int16_t)value;
        break;
    case 8:
        search.budget_seconds = value;
        break;
    case 9:
        start_ticks = (uint32_t)value;
        break;
    case 10:
        generation.bingo_bonus = (uint32_t)value;
        break;
    case 11:
        tree.free_head=(uint16_t)value;break;
    case 12:
        tree.current=(uint16_t)value;break;
    default:
        __builtin_trap();
    }
}
uint32_t maven_endgame_get(unsigned id) {
    switch (id) {
    case 0:
        return (uint32_t)application.row_zero_count;
    case 1:
        return (uint32_t)application.new_tiles;
    case 2:
        return (uint32_t)application.recorded_row[0];
    case 3:
        return (uint32_t)application.recorded_row[1];
    case 4:
        return (uint32_t)application.recorded_column[0];
    case 5:
        return (uint32_t)application.recorded_column[1];
    case 6:
        return generation.ranking.cutoff_bits;
    case 7:
        return generation.ranking.count;
    case 8:
        return search.iterations;
    case 9:
        return clock_index;
    case 10:
        return generation.bingo_bonus;
    case 11:
        return tree.free_head;
    case 12:
        return tree.current;
    case 13:
        return generation.mask_count;
    case 14:
        return poll_calls;
    case 15:
        return empty_pool_polls;
    default:
        __builtin_trap();
    }
}
unsigned maven_endgame_run(void) {
    clock_index = poll_calls = empty_pool_polls = 0;
    return maven_search_endgame(&search);
}
