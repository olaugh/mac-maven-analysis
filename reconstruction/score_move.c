#include "score_move.h"
#include <string.h>
static int32_t signed_long(uint32_t x) {
    return x < UINT32_C(0x80000000) ? (int32_t)x : (int32_t)((int64_t)x - INT64_C(0x100000000));
}
static int16_t signed_byte(uint8_t x) { return x < 128 ? x : (int16_t)x - 256; }
static int16_t signed_word(uint16_t x) {
    return x < 32768 ? (int16_t)x : (int16_t)((int32_t)x - 65536);
}
static uint32_t blank_cost(int16_t row, int16_t column, uint32_t multiplier,
                           const MavenScoreInput *s) {
    unsigned cell = (unsigned)(row * 17 + column);
    if ((row != 16 && s->board[(row - 1) * 17 + column]) ||
        (row != 15 && s->board[(row + 1) * 17 + column]))
        multiplier += (uint32_t)(int32_t)signed_byte(s->word_multipliers[cell]);
    return multiplier * (uint32_t)(int32_t)signed_byte(s->letter_multipliers[cell]);
}
static MavenScoreScan score_move(const uint8_t *move, const uint8_t *rack, uint8_t *remaining_rack,
                                 const MavenScoreInput *s, uint32_t bonus,
                                 int suppress_main_multiplier, int pool) {
    MavenScoreScan result;
    int16_t row = signed_byte(move[32]), column;
    int missing;
    unsigned i;
    const uint8_t *p;
    if (!row) {
        memset(&result, 0, sizeof result);
        return result;
    }
    result = pool ? maven_accumulate_pool_move_score(move, rack, s, bonus, suppress_main_multiplier)
                  : maven_accumulate_move_score_with_main_control(move, rack, s, bonus,
                                                                  suppress_main_multiplier);
    missing = result.initial_blanks - result.remaining_blanks;
    if (missing) {
        uint32_t cost[2] = {30000, 30000};
        result.zero_value_row[1] = row;
        if (missing != 1)
            result.zero_value_row[0] = row;
        for (p = move, column = signed_byte(move[33]); *p; ++p, ++column) {
            uint32_t candidate;
            unsigned cell = (unsigned)(row * 17 + column);
            if (s->board[cell])
                continue;
            if (*p != result.missing_letters[0] &&
                (missing == 1 || *p != result.missing_letters[1]))
                continue;
            if (missing != 1 && result.missing_letters[0] != result.missing_letters[1] &&
                !(s->letter_class[*p] & 192))
                s->diagnostic(s->user);
            candidate = blank_cost(row, column, result.word_multiplier, s);
            if (missing == 1) {
                if (signed_long(candidate) < signed_long(cost[0])) {
                    cost[0] = candidate;
                    result.zero_value_column[1] = column;
                }
            } else if (result.missing_letters[0] != result.missing_letters[1]) {
                i = *p == result.missing_letters[0] ? 0 : 1;
                if (signed_long(candidate) < signed_long(cost[i])) {
                    cost[i] = candidate;
                    result.zero_value_column[1 - i] = column;
                }
            } else if (signed_long(candidate) < signed_long(cost[1])) {
                if (signed_long(candidate) < signed_long(cost[0])) {
                    result.zero_value_column[0] = result.zero_value_column[1];
                    cost[1] = cost[0];
                    result.zero_value_column[1] = column;
                    cost[0] = candidate;
                } else {
                    result.zero_value_column[0] = column;
                    cost[1] = candidate;
                }
            }
        }
        if (missing != 1)
            result.score_bits -= cost[1] * (uint32_t)(int32_t)signed_word(
                                               s->letter_values[result.missing_letters[1]]);
        result.score_bits -=
            cost[0] * (uint32_t)(int32_t)signed_word(s->letter_values[result.missing_letters[0]]);
        if (signed_long(result.score_bits) < 0)
            s->diagnostic(s->user);
    }
    for (p = s->alphabet; *p; ++p)
        for (i = 0; (int32_t)i < result.remaining_counts[*p]; ++i)
            *remaining_rack++ = *p;
    *remaining_rack = 0;
    return result;
}

MavenScoreScan maven_score_move(const uint8_t *move, const uint8_t *rack, uint8_t *remaining,
                                const MavenScoreInput *input) {
    return maven_score_move_with_bonus(move, rack, remaining, input, 5000);
}

MavenScoreScan maven_score_move_with_bonus(const uint8_t *move, const uint8_t *rack,
                                           uint8_t *remaining, const MavenScoreInput *input,
                                           uint32_t bonus) {
    return maven_score_move_with_main_control(move, rack, remaining, input, bonus, 0);
}

MavenScoreScan maven_score_move_with_main_control(const uint8_t *move, const uint8_t *rack,
                                                  uint8_t *remaining, const MavenScoreInput *input,
                                                  uint32_t bonus, int suppress) {
    return score_move(move, rack, remaining, input, bonus, suppress, 0);
}
MavenScoreScan maven_score_pool_move(const uint8_t *move, const uint8_t *rack, uint8_t *remaining,
                                     const MavenScoreInput *input, uint32_t bonus, int suppress) {
    return score_move(move, rack, remaining, input, bonus, suppress, 1);
}
