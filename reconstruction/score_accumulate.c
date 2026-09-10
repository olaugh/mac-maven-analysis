#include "score_accumulate.h"
#include <string.h>
static int16_t signed_word(uint16_t x) {
    return x < 32768 ? (int16_t)x : (int16_t)((int32_t)x - 65536);
}
static int16_t signed_byte(uint8_t x) { return x < 128 ? x : (int16_t)x - 256; }
static uint32_t sign_word_bits(uint16_t x) { return (uint32_t)(int32_t)signed_word(x); }
static MavenScoreScan accumulate(const uint8_t *move, const uint8_t *rack, const MavenScoreInput *s,
                                 uint32_t bonus, int suppress_main_multiplier, int tile_limit) {
    int16_t counts[128] = {0};
    const uint8_t *p;
    unsigned missing = 0;
    int16_t row = signed_byte(move[32]), column = signed_byte(move[33]);
    uint32_t main_sum = 0, word_multiplier = 1;
    MavenScoreScan result;
    memset(&result, 0, sizeof result);
    for (p = rack; *p; ++p)
        counts[*p] = signed_word((uint16_t)(counts[*p] + 1));
    result.initial_blanks = result.remaining_blanks = counts['?'];
    for (p = move; *p; ++p, ++column) {
        unsigned cell = (unsigned)(row * 17 + column);
        uint8_t letter = *p;
        if (!(s->letter_class[letter] & 128))
            s->diagnostic(s->user);
        if (!s->board[cell]) {
            int16_t letter_value = signed_word(s->letter_values[letter]);
            int16_t letter_multiplier = signed_byte(s->letter_multipliers[cell]);
            int16_t multiplier = signed_byte(s->word_multipliers[cell]);
            word_multiplier *= (uint32_t)(int32_t)multiplier;
            ++result.new_tiles;
            if (result.new_tiles > tile_limit || result.new_tiles <= 0)
                s->diagnostic(s->user);
            if (!counts[letter]) {
                --result.remaining_blanks;
                result.missing_letters[missing++] = letter;
                if (result.remaining_blanks < 0)
                    result.score_bits = UINT32_C(0xffff3cb0);
            } else
                --counts[letter];
            main_sum += sign_word_bits((uint16_t)(letter_multiplier * letter_value));
            if ((row != 16 && s->board[(row - 1) * 17 + column]) ||
                (row != 15 && s->board[(row + 1) * 17 + column])) {
                int32_t scan;
                uint32_t cross_sum = 0;
                for (scan = row - 1; scan != 0 && scan != 15 && s->board[scan * 17 + column];
                     --scan)
                    cross_sum += sign_word_bits(s->values[scan * 17 + column]);
                for (scan = row + 1; scan != 31 && scan != 16 && s->board[scan * 17 + column];
                     ++scan)
                    cross_sum += sign_word_bits(s->values[scan * 17 + column]);
                cross_sum += sign_word_bits((uint16_t)(letter_multiplier * letter_value));
                result.score_bits += cross_sum * (uint32_t)(int32_t)multiplier;
            }
        } else if (s->values[cell])
            main_sum += sign_word_bits(s->values[cell]);
        else {
            result.zero_value_row[1] = result.zero_value_row[0];
            result.zero_value_column[1] = result.zero_value_column[0];
            result.zero_value_row[0] = row;
            result.zero_value_column[0] = column;
        }
    }
    if (suppress_main_multiplier)
        word_multiplier = 1;
    if (word_multiplier != 1 && word_multiplier != 2 && word_multiplier != 3 &&
        word_multiplier != 4 && word_multiplier != 9 && word_multiplier != 27)
        s->diagnostic(s->user);
    result.score_bits += main_sum * word_multiplier + (result.new_tiles == 7 ? bonus : 0);
    result.word_multiplier = word_multiplier;
    counts['?'] = result.remaining_blanks;
    memcpy(result.remaining_counts, counts, sizeof counts);
    return result;
}

MavenScoreScan maven_accumulate_move_score(const uint8_t *move, const uint8_t *rack,
                                           const MavenScoreInput *input) {
    return maven_accumulate_move_score_with_bonus(move, rack, input, 5000);
}

MavenScoreScan maven_accumulate_move_score_with_bonus(const uint8_t *move, const uint8_t *rack,
                                                      const MavenScoreInput *input,
                                                      uint32_t bonus) {
    return maven_accumulate_move_score_with_main_control(move, rack, input, bonus, 0);
}

MavenScoreScan maven_accumulate_move_score_with_main_control(const uint8_t *move,
                                                             const uint8_t *rack,
                                                             const MavenScoreInput *input,
                                                             uint32_t bonus, int suppress) {
    return accumulate(move, rack, input, bonus, suppress, 7);
}
MavenScoreScan maven_accumulate_pool_move_score(const uint8_t *move, const uint8_t *rack,
                                                const MavenScoreInput *input, uint32_t bonus,
                                                int suppress) {
    return accumulate(move, rack, input, bonus, suppress, 15);
}
