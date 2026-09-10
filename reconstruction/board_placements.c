#include "board_placements.h"
#include "board_state.h"
#include "cross_check_letters.h"
#include <stddef.h>
#include <string.h>

typedef struct {
    MavenBoardEnumeration *state;
    MavenBoardPlacement placement;
    const uint8_t *row;
    uint32_t cross_masks[17];
    uint16_t cross_multipliers[17];
    size_t length;
    unsigned anchor;
    int (*stop)(void *);
    void *stop_user;
    int stopped;
} RowTraversal;

static int should_stop(RowTraversal *traversal) {
    if (!traversal->stopped && traversal->stop)
        traversal->stopped = traversal->stop(traversal->stop_user);
    return traversal->stopped;
}
static uint32_t read_node(const RowTraversal *traversal, uint32_t index) {
    const uint8_t *p =
        traversal->state->sections[traversal->placement.section].records + (size_t)index * 4;
    return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3];
}
static uint32_t letter_bit(uint8_t letter) {
    /* The lexicon includes space-suffixed entries. They have no tile bit;
     * avoid undefined shifts when their nodes follow a board prefix. */
    return letter >= 'a' && letter <= 'z' ? UINT32_C(1) << (letter - 'a') : 0;
}
static uint8_t tile_to_consume(const RowTraversal *traversal, uint8_t letter) {
    return traversal->state->remaining[letter] ? letter : (uint8_t)'?';
}
static void extend_right(RowTraversal *traversal, uint32_t parent, unsigned column) {
    uint8_t fixed_letter = traversal->row[column];
    uint32_t index = parent >> 10, node;
    if (should_stop(traversal))
        return;
    if (fixed_letter) {
        /* The original also enters node0 when a terminal prefix meets an
         * occupied square; valid dictionary node0 cannot match a board letter. */
        do {
            node = read_node(traversal, index++);
        } while (!(node & 0x200) && (uint8_t)node < fixed_letter);
        if ((uint8_t)node == fixed_letter) {
            traversal->placement.word[traversal->length++] = fixed_letter;
            extend_right(traversal, node, column + 1);
            --traversal->length;
        }
        return;
    }
    if (parent & 0x100) {
        traversal->placement.word[traversal->length] = 0;
        traversal->placement.column = (uint8_t)(column - traversal->length);
        traversal->state->placement(traversal->state->user, &traversal->placement,
                                    traversal->state->remaining);
    }
    if (should_stop(traversal) || !index || !traversal->cross_masks[column])
        return;
    do {
        uint8_t letter, consumed;
        node = read_node(traversal, index++);
        letter = (uint8_t)node;
        if (!(traversal->cross_masks[column] & letter_bit(letter)))
            continue;
        consumed = tile_to_consume(traversal, letter);
        if (!traversal->state->remaining[consumed])
            continue;
        traversal->placement.word[traversal->length++] = letter;
        --traversal->state->remaining[consumed];
        extend_right(traversal, node, column + 1);
        ++traversal->state->remaining[consumed];
        --traversal->length;
    } while (!(node & 0x200) && !should_stop(traversal));
}
static void left_part(RowTraversal *traversal, uint32_t parent, unsigned limit) {
    uint32_t index = parent >> 10, node;
    if (should_stop(traversal))
        return;
    do {
        uint8_t letter, consumed;
        node = read_node(traversal, index++);
        if (!(node >> 10))
            continue;
        letter = (uint8_t)node;
        consumed = tile_to_consume(traversal, letter);
        if (!traversal->state->remaining[consumed])
            continue;
        traversal->placement.word[traversal->length++] = letter;
        --traversal->state->remaining[consumed];
        /* A left part alone must not emit before covering the anchor. */
        node &= ~UINT32_C(0x100);
        extend_right(traversal, node, traversal->anchor);
        if (limit > 1)
            left_part(traversal, node, limit - 1);
        ++traversal->state->remaining[consumed];
        --traversal->length;
    } while (!(node & 0x200) && !should_stop(traversal));
}
static uint32_t crossing_mask(const MavenBoardEnumeration *state, int16_t row, int16_t column,
                              const uint8_t *allowed,uint8_t *workspace) {
    int16_t cross_row, cross_column;
    const uint8_t *prefix, *suffix;
    const MavenDictionarySection *section;
    uint32_t mask = 0;
    maven_cross_coordinates(row, column, &cross_row, &cross_column);
    prefix = maven_word_start_before(state->board, cross_row, cross_column);
    suffix = state->board + cross_row * 17 + cross_column + 1;
    if(workspace){
        uint8_t *letter;
        maven_cross_check_letters(state->sections,prefix,suffix,allowed,workspace);
        for(letter=workspace;*letter;++letter)mask|=letter_bit(*letter);
        return mask;
    }
    for (section = state->sections; section->root_index; ++section) {
        MavenDictionarySection one_section[2] = {*section, {0, 0}};
        uint8_t letters[27], *letter;
        maven_cross_check_letters(one_section, prefix, suffix, allowed, letters);
        for (letter = letters; *letter; ++letter)
            mask |= letter_bit(*letter);
    }
    return mask;
}
void maven_enumerate_board_placements_shared(MavenBoardEnumeration *state,uint8_t workspace[64],
    void (*row_ready)(void *,unsigned),void *row_user,int (*stop)(void *),void *stop_user) {
    RowTraversal traversal;
    uint8_t allowed[27];
    uint32_t available_mask = 0;
    unsigned letter, count = 0, row;
    memset(&traversal, 0, sizeof traversal);
    traversal.state = state;
    traversal.stop = stop;
    traversal.stop_user = stop_user;
    for (letter = 'a'; letter <= 'z'; ++letter)
        if (state->remaining['?'] || state->remaining[letter]) {
            allowed[count++] = (uint8_t)letter;
            available_mask |= letter_bit((uint8_t)letter);
        }
    allowed[count] = 0;
    for (row = 1; row <= 30 && !should_stop(&traversal); ++row) {
        unsigned column, previous_anchor = 0;
        int has_connection = 0;
        uint16_t anchor_mask = state->row_anchor_masks ? state->row_anchor_masks[row] : UINT16_MAX;
        if (!anchor_mask)
            continue;
        traversal.row = state->board + row * 17;
        traversal.placement.row = (uint8_t)row;
        memset(traversal.cross_masks, 0, sizeof traversal.cross_masks);
        memset(traversal.cross_multipliers, 0, sizeof traversal.cross_multipliers);
        for (column = 1; column <= 15; ++column) {
            unsigned cell = row * 17 + column;
            if (traversal.row[column]) {
                traversal.cross_masks[column] = letter_bit(traversal.row[column]);
                has_connection = 1;
            } else if ((row != 1 && row != 16 && state->board[cell - 17]) ||
                       (row != 15 && row != 30 && state->board[cell + 17])) {
                traversal.cross_masks[column] =
                    crossing_mask(state, (int16_t)row, (int16_t)column, allowed,workspace);
                traversal.cross_multipliers[column] =
                    (uint16_t)(state->word_multipliers[cell] * state->letter_multipliers[cell]);
                if (traversal.cross_masks[column])
                    has_connection = 1;
            } else {
                traversal.cross_masks[column] = available_mask;
            }
        }
        if (!has_connection)
            continue;
        if(row_ready)row_ready(row_user,row);
        for (column = 1; column <= 15 && !should_stop(&traversal); ++column) {
            const MavenDictionarySection *section;
            if (traversal.row[column] || !(traversal.cross_multipliers[column] ||
                                           traversal.row[column - 1] || traversal.row[column + 1]))
                continue;
            traversal.anchor = column;
            if ((anchor_mask & (1u << column)) && traversal.cross_masks[column]) {
                /* CODE37+0xc6a clears the word once per eligible anchor,
                 * preserving subsequent stale tail bytes across sections. */
                memset(traversal.placement.word, 0, sizeof traversal.placement.word);
                traversal.placement.section = 0;
                for (section = state->sections; section->root_index && !should_stop(&traversal);
                     ++section, ++traversal.placement.section) {
                    traversal.length = 0;
                    if (traversal.row[column - 1]) {
                        const uint8_t *prefix =
                            maven_word_start_before(state->board, (int16_t)row, (int16_t)column);
                        int32_t child = maven_prefix_children(section, prefix);
                        if (child <= 0)
                            continue;
                        traversal.length = strlen((const char *)prefix);
                        memcpy(traversal.placement.word, prefix, traversal.length + 1);
                        extend_right(&traversal, (uint32_t)child << 10, column);
                    } else {
                        unsigned limit = column - previous_anchor - 1;
                        extend_right(&traversal, (uint32_t)section->root_index << 10, column);
                        if (limit > 7)
                            limit = 7;
                        if (limit)
                            left_part(&traversal, (uint32_t)section->root_index << 10, limit);
                    }
                }
            }
            previous_anchor = column;
        }
    }
}

void maven_enumerate_board_placements_until(MavenBoardEnumeration *state,int (*stop)(void *),void *user){
    maven_enumerate_board_placements_shared(state,NULL,NULL,NULL,stop,user);
}

void maven_enumerate_board_placements(MavenBoardEnumeration *state) {
    maven_enumerate_board_placements_until(state, NULL, NULL);
}
