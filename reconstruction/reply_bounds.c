#include "reply_bounds.h"
#include <string.h>
static uint32_t read_long(const uint8_t *p) {
    return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3];
}
static int64_t signed_long(uint32_t x) {
    return x <= INT32_MAX ? x : (int64_t)x - INT64_C(4294967296);
}
static int16_t signed_word(uint16_t x) {
    return x < 32768 ? (int16_t)x : (int16_t)((int32_t)x - 65536);
}
void maven_clear_reply_conflicts(MavenReplyConflicts *s) { memset(s->groups, 0, sizeof s->groups); }
uint32_t maven_reply_conflicts_with_move(MavenReplyConflicts *s, const MavenReplySummary *reply,
                                         const uint8_t move[34]) {
    unsigned group = reply->identifier / 32, bit = reply->identifier % 32;
    if (!s->groups[group].valid) {
        unsigned cell = 17u * move[32] + move[33], i;
        uint32_t bits = 0;
        for (i = 0; move[i]; ++i)
            if (!s->board[cell + i])
                bits |= s->cell_conflicts[group][cell + i];
        s->groups[group].bits = bits;
        s->groups[group].valid = 1;
    }
    return s->bit_masks[bit] & s->groups[group].bits;
}
int maven_bound_move_against_replies(MavenReplyBounds *s, const uint8_t move[34], uint32_t *upper,
                                     uint32_t *lower, int16_t *empty_seen,
                                     int16_t *compatible_seen) {
    uint32_t minimum_upper = 200000000, minimum_lower = 200000000, score = read_long(move + 16);
    int16_t *link = &s->cache->first;
    int pruned = 0;
    int16_t mask = signed_word((uint16_t)((uint16_t)move[30] << 8 | move[31]));
    *empty_seen = 0;
    maven_clear_reply_conflicts(s->conflicts);
    while (*link >= 0) {
        int16_t index = *link;
        MavenReplySummary *reply = &s->cache->replies[index];
        if (!maven_reply_conflicts_with_move(s->conflicts, reply, move)) {
            uint32_t low, high;
            if (reply->emptied_rack) {
                low = high = score - reply->score_bits -
                             (uint32_t)(2 * (int32_t)signed_word(s->kept_tile_points[mask]));
                *empty_seen = 1;
            } else {
                int16_t positive, negative;
                int16_t value = s->paired_masks(s->user, mask, (int16_t)(int8_t)reply->kept_mask,
                                                &positive, &negative);
                uint32_t base = score - reply->score_bits + (uint32_t)(int32_t)value;
                high = base + (uint32_t)(int32_t)positive;
                low = base - (uint32_t)(int32_t)negative;
            }
            if (signed_long(high) < signed_long(minimum_upper))
                minimum_upper = high;
            if (signed_long(low) < signed_long(minimum_lower))
                minimum_lower = low;
            if (signed_long(minimum_upper) < signed_long(*upper) &&
                signed_long(minimum_lower) < signed_long(*lower)) {
                *link = reply->next;
                reply->next = s->cache->first;
                s->cache->first = index;
                pruned = 1;
                break;
            }
        }
        link = &reply->next;
    }
    if (minimum_upper == 200000000) {
        int16_t positive, negative;
        uint32_t base = score + (uint32_t)(int32_t)s->own_mask(s->user, mask, &positive, &negative);
        minimum_upper = base + (uint32_t)(int32_t)positive;
        minimum_lower = base - (uint32_t)(int32_t)negative;
        *compatible_seen = 0;
    } else
        *compatible_seen = 1;
    *upper = minimum_upper;
    *lower = minimum_lower;
    return pruned;
}

void maven_build_reply_conflict_map(uint32_t matrix[8][544], const uint8_t board[544],
                                    const MavenEndgameMoveCache *cache,
                                    const uint32_t bit_masks[32]) {
    int16_t index;
    unsigned group, row, col;
    memset(matrix, 0, 8 * 544 * sizeof(uint32_t));
    for (index = cache->first; index >= 0; index = cache->replies[index].next) {
        const MavenReplySummary *reply = &cache->replies[index];
        uint32_t bit = bit_masks[reply->identifier % 32];
        unsigned end;
        group = reply->identifier / 32;
        row = reply->row;
        col = reply->column;
        if (!row)
            continue;
        if (col != 1)
            matrix[group][row * 17 + col - 1] |= bit;
        end = col + reply->length;
        for (; col < end; ++col)
            if (!board[row * 17 + col]) {
                unsigned r;
                matrix[group][row * 17 + col] |= bit;
                for (r = row + 1; r != 16 && r != 31; ++r)
                    if (!board[r * 17 + col]) {
                        matrix[group][r * 17 + col] |= bit;
                        break;
                    }
                for (r = row - 1; r != 0 && r != 15; --r)
                    if (!board[r * 17 + col]) {
                        matrix[group][r * 17 + col] |= bit;
                        break;
                    }
            }
        if (col != 16)
            matrix[group][row * 17 + col] |= bit;
    }
    for (group = 0; group < 8; ++group) {
        for (row = 0; row < 31; ++row)
            matrix[group][row * 17] = matrix[group][row * 17 + 16] = 0;
        for (col = 0; col < 17; ++col)
            matrix[group][col] = matrix[group][31 * 17 + col] = 0;
        for (row = 0; row < 16; ++row)
            for (col = 0; col < 16; ++col) {
                unsigned normal = row * 17 + col, transposed = (col + 15) * 17 + row;
                uint32_t bits = matrix[group][normal] | matrix[group][transposed];
                matrix[group][normal] = matrix[group][transposed] = bits;
            }
    }
}
