#include "late_setup.h"
#include <string.h>
static int16_t word(uint16_t x) { return x < 32768 ? (int16_t)x : (int16_t)((int32_t)x - 65536); }
static int16_t byte(uint8_t x) { return x < 128 ? x : (int16_t)x - 256; }
void maven_prepare_late_priorities(MavenLatePool *s, const uint8_t *own, const uint8_t *alphabet,
                                   const uint8_t *priority_order, MavenPatternEntry *patterns,
                                   int16_t pattern_count, const uint8_t *score_records,
                                   const uint8_t *held_u_query, uint16_t *held_u_value) {
    uint8_t sorted[28], recent[4] = {0};
    uint32_t *stamp;
    unsigned i, j, length = (unsigned)strlen((const char *)priority_order);
    s->aggregate_leave_bits = 0;
    for (i = 0; alphabet[i]; ++i) {
        uint8_t ch = alphabet[i], query[3] = {ch, 0, 0};
        int16_t score = maven_lookup_pattern(patterns, pattern_count, query, score_records, &stamp);
        s->letter_leave[ch] = (uint16_t)score;
        if (score > 0)
            s->aggregate_leave_bits +=
                (uint32_t)(int32_t)word((uint16_t)(byte(s->available[ch]) * score));
        if (byte(s->available[ch]) > 1) {
            int16_t product;
            query[1] = ch;
            score = maven_lookup_pattern(patterns, pattern_count, query, score_records, &stamp);
            product = word((uint16_t)(7 * score));
            product = word((uint16_t)(product * (byte(s->available[ch]) - 1)));
            s->letter_leave[ch] =
                (uint16_t)(s->letter_leave[ch] + product / (int16_t)s->unseen_count);
        }
    }
    s->letter_leave['j'] -= 500;
    s->letter_leave['q'] -= 3000;
    s->letter_leave['z'] -= 1000;
    *held_u_value = (uint16_t)maven_lookup_pattern(patterns, pattern_count, held_u_query,
                                                   score_records, &stamp);
    memcpy(sorted, priority_order, length + 1);
    for (i = 0; i < length; ++i) {
        int16_t best = word((uint16_t)(10 * word(s->letter_values[sorted[i]]) -
                                       30 * byte(s->available[sorted[i]]) +
                                       (strchr((const char *)priority_order, sorted[i]) -
                                        (const char *)priority_order)));
        for (j = i + 1; j < length; ++j) {
            int16_t score = word((uint16_t)(10 * word(s->letter_values[sorted[j]]) -
                                            30 * byte(s->available[sorted[j]]) +
                                            (strchr((const char *)priority_order, sorted[j]) -
                                             (const char *)priority_order)));
            if (score < best) {
                uint8_t saved = sorted[i];
                sorted[i] = sorted[j];
                sorted[j] = saved;
                best = score;
            }
        }
    }
    for (i = 0; i < length; ++i)
        if (s->available[sorted[i]]) {
            recent[3] = recent[2];
            recent[2] = recent[1];
            recent[1] = recent[0];
            recent[0] = sorted[i];
        }
    if (s->unseen_count > 10 && word(s->letter_values[recent[1]]) < word(s->letter_values['b']))
        recent[1] = recent[2] = recent[3] = 0;
    if (s->unseen_count > 13 && word(s->letter_values[recent[2]]) <= word(s->letter_values['b']))
        recent[2] = recent[3] = 0;
    /* Stored record byte order is third, first, fourth, second priority. */
    s->priority_letters[0] = recent[2];
    s->priority_letters[1] = recent[0];
    s->priority_letters[2] = recent[3];
    s->priority_letters[3] = recent[1];
    s->per_tile_adjustment =
        (int16_t)((strchr((const char *)own, 'q') || s->available['q'] ? -500 : 0) /
                  ((int16_t)s->unseen_count - 7));
}
int maven_late_merge_anchors(uint16_t anchors[31], const MavenLatePool *s,
                             const uint8_t board[544]) {
    unsigned i;
    memset(anchors, 0, 62);
    for (i = 0; i < s->count; ++i) {
        unsigned row = s->records[i][48], col = s->records[i][49];
        if (!row || row > 30 || !col || col > 15)
            return 0;
        for (; col < 16; ++col) {
            unsigned at = row * 17 + col;
            if (!board[at] && (board[at - 1] || board[at + 1] || (row != 16 && board[at - 17]) ||
                               (row != 15 && board[at + 17])))
                break;
        }
        if (col == 16)
            return 0;
        anchors[row] |= (uint16_t)(1u << col);
    }
    return 1;
}
uint16_t maven_late_used_tiles(uint8_t used[128], const uint8_t move[34], const uint8_t board[544],
                               const uint8_t available[128]) {
    unsigned i, at = move[32] * 17 + move[33];
    uint16_t total = 0;
    memset(used, 0, 128);
    for (i = 0; move[i]; ++i)
        if (!board[at + i]) {
            ++total;
            if (used[move[i]] == available[move[i]])
                ++used['?'];
            else
                ++used[move[i]];
        }
    return total;
}
int maven_late_add_constraint(MavenLateConstraints *s, uint16_t mask, const MavenPoolWeights *pool,
                              uint8_t counts[128], const uint16_t occurrences[128][8],
                              const uint16_t choose[][8]) {
    unsigned i;
    if (mask == 65535)
        return 1;
    if (s->count >= 181)
        return 0;
    s->masks[s->count] = mask;
    for (i = 0; s->masks[i] != mask; ++i) {
    }
    if (i == s->count) {
        s->weights[s->count] = maven_count_pool_racks(
            pool, counts, (uint16_t)(mask & ((1u << pool->total) - 1)), occurrences, choose);
        ++s->count;
    }
    return 1;
}
uint16_t maven_late_constraint_indices(uint16_t *out, const MavenLateConstraints *s,
                                       uint16_t required) {
    unsigned i;
    uint16_t count = 0;
    for (i = 1; i < s->count; ++i)
        if ((s->masks[i] | required) == required)
            out[count++] = (uint16_t)i;
    out[count++] = 0;
    return count;
}
