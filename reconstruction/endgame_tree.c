#include "endgame_tree.h"
#include <string.h>
static int16_t signed_word(uint16_t x) {
    return x < 32768 ? (int16_t)x : (int16_t)((int32_t)x - 65536);
}
static int16_t signed_byte(uint8_t x) { return x < 128 ? x : (int16_t)x - 256; }
static void write_word(uint8_t *p, uint16_t x) {
    p[0] = (uint8_t)(x >> 8);
    p[1] = (uint8_t)x;
}
static void write_long(uint8_t *p, uint32_t x) {
    p[0] = (uint8_t)(x >> 24);
    p[1] = (uint8_t)(x >> 16);
    p[2] = (uint8_t)(x >> 8);
    p[3] = (uint8_t)x;
}
void maven_endgame_tree_reset(MavenEndgameTree *tree) {
    unsigned i;
    memset(tree->nodes, 0, (size_t)tree->capacity * sizeof *tree->nodes);
    tree->free_head = 1;
    for (i = 0; i + 1 < tree->capacity; ++i)
        tree->nodes[i].next_sibling = (uint16_t)(i + 1);
}
void maven_endgame_prepend_child(MavenEndgameTree *tree, uint16_t parent, uint16_t child) {
    if (parent >= tree->capacity || child >= tree->capacity ||
        tree->nodes[parent].first_child == child)
        tree->diagnostic(tree->user);
    tree->nodes[child].next_sibling = tree->nodes[parent].first_child;
    tree->nodes[parent].first_child = child;
}
uint16_t maven_endgame_select_child(const MavenEndgameTree *tree, uint16_t index) {
    const MavenEndgameNode *node = &tree->nodes[index];
    int avoid_pass = index != 0 && !node->placed_tiles[0];
    int32_t best = -200000000;
    uint16_t child = node->first_child, selected = 0;
    while (child) {
        const MavenEndgameNode *candidate = &tree->nodes[child];
        int32_t value = (int32_t)candidate->move_score - candidate->lower;
        if (value > best && (!avoid_pass || candidate->placed_tiles[0])) {
            best = value;
            selected = child;
        }
        child = candidate->next_sibling;
    }
    return selected;
}
void maven_endgame_recompute_bounds(MavenEndgameTree *tree, uint16_t index) {
    MavenEndgameNode *node = &tree->nodes[index];
    uint16_t child = node->first_child;
    int32_t lower = -200000000, upper = lower;
    if (!child || node->mark)
        return;
    node->mark = 1;
    while (child) {
        MavenEndgameNode *candidate = &tree->nodes[child];
        int32_t lo, hi;
        if (child == candidate->next_sibling)
            tree->diagnostic(tree->user);
        maven_endgame_recompute_bounds(tree, child);
        hi = (int32_t)candidate->move_score - candidate->lower;
        lo = (int32_t)candidate->move_score - candidate->upper;
        if (hi > upper)
            upper = hi;
        if (lo > lower)
            lower = lo;
        child = candidate->next_sibling;
    }
    if (lower > upper)
        tree->diagnostic(tree->user);
    node->lower = signed_word((uint16_t)lower);
    node->upper = signed_word((uint16_t)upper);
    node->mark = 0;
}
void maven_endgame_prune(MavenEndgameTree *tree, uint16_t index) {
    MavenEndgameNode *node = &tree->nodes[index];
    uint16_t child, *link;
    int32_t best = -200000000;
    if (index == tree->current)
        return;
    if (node->mark || (node->emptied_rack && node->first_child))
        tree->diagnostic(tree->user);
    node->mark = 1;
    for (child = node->first_child; child; child = tree->nodes[child].next_sibling) {
        MavenEndgameNode *candidate = &tree->nodes[child];
        int32_t guaranteed = (int32_t)candidate->move_score - candidate->upper;
        if (guaranteed > best)
            best = guaranteed;
    }
    link = &node->first_child;
    while ((child = *link) != 0) {
        MavenEndgameNode *candidate = &tree->nodes[child];
        int32_t possible = (int32_t)candidate->move_score - candidate->lower;
        if (best > possible || (best == possible && candidate->lower != candidate->upper)) {
            *link = candidate->next_sibling;
        } else {
            if (candidate->lower == candidate->upper)
                candidate->first_child = 0;
            else
                maven_endgame_prune(tree, child);
            link = &candidate->next_sibling;
        }
    }
    node->mark = 0;
}
void maven_endgame_mark(MavenEndgameTree *tree, uint16_t index, uint8_t mark) {
    MavenEndgameNode *node = &tree->nodes[index];
    uint16_t child;
    if (node->mark == mark)
        return;
    node->mark = mark;
    for (child = node->first_child; child; child = tree->nodes[child].next_sibling)
        maven_endgame_mark(tree, child, mark);
}
void maven_endgame_sweep(MavenEndgameTree *tree) {
    unsigned i;
    for (i = 0; i < tree->capacity; ++i)
        if (!tree->nodes[i].mark) {
            memset(&tree->nodes[i], 0, sizeof tree->nodes[i]);
            tree->nodes[i].next_sibling = tree->free_head;
            tree->free_head = (uint16_t)i;
        }
}
uint16_t maven_endgame_allocate_node(MavenEndgameTree *tree) {
    uint16_t index;
    if (!tree->free_head) {
        maven_endgame_prune(tree, 0);
        maven_endgame_mark(tree, 0, 1);
        if (tree->poll)
            tree->poll(tree->user);
        maven_endgame_sweep(tree);
        maven_endgame_mark(tree, 0, 0);
        if (!tree->free_head)
            return 0;
    }
    index = tree->free_head;
    if (index >= tree->capacity)
        tree->diagnostic(tree->user);
    tree->free_head = tree->nodes[index].next_sibling;
    memset(&tree->nodes[index], 0, sizeof tree->nodes[index]);
    return index;
}
uint16_t maven_endgame_find_hash(const MavenEndgameTree *tree, uint16_t index, uint32_t hash,
                                 int16_t passes) {
    const MavenEndgameNode *node = &tree->nodes[index];
    uint16_t child;
    if (passes == 2)
        return UINT16_MAX;
    if (node->position_hash == hash)
        return index;
    for (child = node->first_child; child; child = tree->nodes[child].next_sibling) {
        uint16_t found = maven_endgame_find_hash(
            tree, child, hash, tree->nodes[child].row ? 0 : (int16_t)(passes + 1));
        if (found != UINT16_MAX)
            return found;
    }
    return UINT16_MAX;
}
uint16_t maven_endgame_add_move(MavenEndgameTree *tree, const uint8_t move[34],
                                const uint8_t board[544], int32_t upper, int32_t lower) {
    uint16_t index = maven_endgame_allocate_node(tree);
    MavenEndgameNode *node;
    const uint8_t *cell;
    unsigned i = 0, n = 0;
    if (!index)
        return 0;
    if (upper < lower)
        tree->diagnostic(tree->user);
    node = &tree->nodes[index];
    node->leave_tag = move[23];
    node->adjustment_tag = move[27];
    node->emptied_rack = move[29];
    node->upper = signed_word((uint16_t)upper);
    node->lower = signed_word((uint16_t)lower);
    maven_endgame_prepend_child(tree, tree->current, index);
    node->move_score = signed_word((uint16_t)((uint16_t)move[18] << 8 | move[19]));
    node->row = move[32];
    node->column = move[33];
    node->kept_mask = move[31];
    cell = board + signed_byte(move[32]) * 17 + signed_byte(move[33]);
    for (; move[i]; ++i)
        if (!cell[i])
            node->placed_tiles[n++] = move[i];
    node->placed_tiles[n] = 0;
    return index;
}
void maven_endgame_expand_move(uint8_t move[34], const MavenEndgameNode *node,
                               const uint8_t board[544]) {
    const uint8_t *cell = board + signed_byte(node->row) * 17 + signed_byte(node->column),
                  *tile = node->placed_tiles;
    uint8_t *out = move;
    write_long(move + 16, (uint32_t)((int32_t)node->move_score * 100));
    write_long(move + 20, 0);
    write_long(move + 24, 0);
    write_word(move + 28, (uint16_t)signed_byte(node->emptied_rack));
    write_word(move + 30, (uint16_t)signed_byte(node->kept_mask));
    move[32] = node->row;
    move[33] = node->column;
    while (*tile || *cell) {
        *out++ = *cell ? *cell : *tile++;
        ++cell;
    }
    *out = 0;
}
uint32_t maven_hash_bytes(const uint8_t *data, size_t size, const uint32_t table[16]) {
    uint32_t value = 0;
    size_t i;
    for (i = 0; i < size; ++i)
        value = (value >> 4) + table[value & 15] + (uint32_t)(int32_t)signed_byte(data[i]);
    return value;
}
uint32_t maven_endgame_position_hash(const uint8_t board[544], const uint8_t *rack,
                                     const uint8_t *other, const uint32_t table[16]) {
    uint32_t hash = maven_hash_bytes(board, 272, table) +
                    maven_hash_bytes(rack, strlen((const char *)rack), table) +
                    2 * maven_hash_bytes(other, strlen((const char *)other), table);
    return hash ? hash : 1;
}

uint16_t maven_endgame_add_pass(MavenEndgameTree *tree) {
    uint16_t index = maven_endgame_allocate_node(tree);
    if (index) {
        MavenEndgameNode *node = &tree->nodes[index], *parent = &tree->nodes[tree->current];
        node->kept_mask = 127;
        maven_endgame_prepend_child(tree, tree->current, index);
        node->lower = signed_word((uint16_t)(-parent->upper));
        node->upper = signed_word((uint16_t)(-parent->lower));
    }
    return index;
}
uint16_t maven_endgame_reuse_position(MavenEndgameTree *tree, uint32_t hash) {
    uint16_t found = maven_endgame_find_hash(tree, 0, hash, 0);
    MavenEndgameNode *current = &tree->nodes[tree->current];
    current->position_hash = hash;
    if (found == UINT16_MAX)
        return found;
    current->first_child = tree->nodes[found].first_child;
    current->upper = tree->nodes[found].upper;
    current->lower = tree->nodes[found].lower;
    return !current->first_child && current->lower != current->upper ? UINT16_MAX : found;
}

MavenEndgameFrontier maven_endgame_choose_frontier(const MavenEndgameTree *tree,
                                                   uint16_t previous) {
    MavenEndgameFrontier out = {0, 0, 0, 0};
    int32_t alternative = -200000000, guaranteed = -200000000, guaranteed_possible = -200000000;
    uint16_t child;
    out.optimistic = maven_endgame_select_child(tree, 0);
    for (child = tree->nodes[0].first_child; child; child = tree->nodes[child].next_sibling) {
        const MavenEndgameNode *node = &tree->nodes[child];
        int32_t possible = (int32_t)node->move_score - node->lower;
        int32_t certain = (int32_t)node->move_score - node->upper;
        if (child != out.optimistic && possible > alternative) {
            out.alternative = child;
            alternative = possible;
        }
        if (certain > guaranteed || (certain == guaranteed && possible > guaranteed_possible)) {
            out.guaranteed = child;
            guaranteed = certain;
            guaranteed_possible = possible;
        }
    }
    out.next_frontier = out.optimistic;
    if (out.optimistic == out.guaranteed && previous == out.optimistic && out.alternative)
        out.next_frontier = out.alternative;
    return out;
}
int maven_endgame_continue_search(const MavenEndgameTree *tree,
                                  const MavenEndgameFrontier *frontier, int16_t initial,
                                  int16_t current, int32_t elapsed, int32_t budget) {
    const MavenEndgameNode *best, *other;
    int16_t reserve = signed_word((uint16_t)((uint16_t)initial + (uint16_t)current));
    if (reserve >= tree->capacity || elapsed >= budget || !frontier->alternative)
        return 0;
    best = &tree->nodes[frontier->optimistic];
    other = &tree->nodes[frontier->alternative];
    if (!best->first_child && !best->emptied_rack)
        return 1;
    return (int32_t)other->move_score - other->lower > (int32_t)best->move_score - best->upper;
}
