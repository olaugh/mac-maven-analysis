#include "leave_table.h"
#include "rack_masks.h"
#include <string.h>
static int16_t signed_word(uint16_t x) {
    return x < 32768 ? (int16_t)x : (int16_t)((int32_t)x - 65536);
}
static int16_t signed_byte(uint8_t x) { return x < 128 ? x : (int16_t)x - 256; }
static int64_t signed_long(uint32_t x) {
    return x <= INT32_MAX ? x : (int64_t)x - INT64_C(4294967296);
}
static int16_t lookup(MavenLeaveTable *state, const uint8_t *letters, uint32_t **stamp) {
    return maven_lookup_pattern(state->patterns, state->pattern_count, letters,
                                state->score_records, stamp);
}
static void propagate(MavenLeaveTable *state, uint16_t mask, uint16_t value) {
    unsigned bit;
    if (state->mask_generations[mask] == state->generation)
        return;
    state->mask_generations[mask] = state->generation;
    state->values[mask] = (uint16_t)(state->values[mask] + value);
    for (bit = 0; bit < 7; ++bit)
        propagate(state, (uint16_t)(mask | (1u << bit)), value);
}
static uint16_t scaled(uint32_t value, int16_t draws, int16_t total) {
    return (uint16_t)(signed_long(value * (uint32_t)(int32_t)draws) / total);
}
static void prepare(MavenLeaveTable *state, const uint8_t *q_query, const uint8_t *blank_query) {
    const int search = q_query != NULL;
    const uint8_t *letter;
    uint32_t expected = 0, *stamp;
    uint16_t unseen_points = 0;
    int16_t total = 0, pool_vowels = 0, pool_consonants, qu_value;
    int mask;
    ++state->generation;
    state->started_generation = state->generation;
    memset(state->values, 0, sizeof state->values);
    memset(state->canonical_masks, 0, sizeof state->canonical_masks);
    state->mask_count = 0;
    maven_build_occurrence_masks(state->sorted_rack, state->occurrence_masks);
    for (letter = state->alphabet; *letter; ++letter) {
        uint8_t query[2] = {*letter, 0};
        int16_t count = signed_byte(state->unseen_counts[*letter]);
        int16_t base = lookup(state, query, &stamp);
        total += count;
        unseen_points =
            (uint16_t)(unseen_points + count * signed_word(state->letter_values[*letter]));
        expected += (uint32_t)(int32_t)signed_word((uint16_t)(count * base));
    }
    for (letter = (const uint8_t *)"aeiou"; *letter; ++letter)
        pool_vowels += signed_byte(state->unseen_counts[*letter]);
    pool_consonants = total - pool_vowels;
    if (4 * total > 10 * pool_vowels) {
        pool_vowels += signed_byte(state->unseen_counts['?']);
        pool_consonants -= signed_byte(state->unseen_counts['?']);
    }
    if (!search)
        expected +=
            (uint32_t)(int32_t)signed_word(state->q_with_unseen_u[state->unseen_counts['u']]);
    qu_value = 0;
    if (search) {
        int16_t q_score = lookup(state, q_query, &stamp);
        expected -= (uint32_t)(int32_t)signed_word(
            (uint16_t)(signed_byte(state->unseen_counts['q']) * q_score));
    } else {
        qu_value = lookup(state, state->held_u_query, &stamp);
    }
    for (mask = 127; mask >= 0; --mask) {
        uint8_t residual[8];
        int position, length = 0, vowels = 0, consonants = 0, blanks = 0, has_q = 0, has_u = 0;
        int16_t draws, score;
        for (position = 0; state->sorted_rack[position]; ++position) {
            uint8_t ch = state->sorted_rack[position];
            if (!(mask & (1u << position)))
                continue;
            residual[length++] = ch;
            if (strchr((const char *)state->vowel_characters, ch)) {
                ++vowels;
                if (ch == 'u')
                    has_u = 1;
            } else if (ch == '?')
                ++blanks;
            else {
                ++consonants;
                if (ch == 'q')
                    has_q = 1;
            }
            if (ch == state->sorted_rack[position + 1] && !(mask & (1u << (position + 1))))
                break;
        }
        if (state->sorted_rack[position])
            continue;
        residual[length] = 0;
        state->canonical_masks[state->mask_count++] = (int16_t)mask;
        if (search || total <= 7) {
            uint16_t points = 0;
            for (letter = residual; *letter; ++letter)
                points = (uint16_t)(points + state->letter_values[*letter]);
            state->tile_points[mask] = points;
            if (!search) {
                state->values[mask] = length ? (uint16_t)(-unseen_points - 2 * points)
                                             : (uint16_t)(2 * unseen_points);
                continue;
            }
        }
        draws = (int16_t)(7 - length);
        if (draws > total - 7)
            draws = total - 7;
        score = maven_lookup_pattern_with_letter_expectation(
            state->patterns, state->pattern_count, residual, state->score_records, &stamp, total,
            state->unseen_counts, state->distribution, state->letter_scores);
        /* A nonzero adjusted score requires the original cache entry; absent
         * nonzero single-letter scores violate the original table contract. */
        if (score && stamp && signed_long(*stamp) <= signed_long(state->started_generation)) {
            if (search) {
                if (strchr((const char *)residual, 'q')) {
                    if (!strcmp((const char *)residual, (const char *)q_query)) {
                        score = signed_word(
                            (uint16_t)(signed_long(expected - (uint32_t)total) / total));
                        if (score > -100)
                            score = -100;
                    } else
                        score = 0;
                } else if (!strcmp((const char *)residual, (const char *)blank_query) &&
                           state->unseen_counts['q'] && !state->unseen_counts['u']) {
                    /* The original lookup replaces the timestamp pointer too. */
                    score = lookup(state, state->held_u_query, &stamp);
                    score = signed_word((uint16_t)(score + 600));
                }
            }
            *stamp = ++state->generation;
            propagate(state, (uint16_t)mask, (uint16_t)score);
        }
        state->values[mask] = (uint16_t)(state->values[mask] +
                                         maven_rack_balance_with_blanks(
                                             state->balance, (int16_t)vowels, (int16_t)consonants,
                                             (int16_t)blanks, pool_vowels, pool_consonants, draws));
        if (!search && has_q && !has_u)
            state->values[mask] =
                (uint16_t)(state->values[mask] +
                           state->q_without_held_u[draws * 5 + state->unseen_counts['u']]);
        if (!search && has_u && state->unseen_counts['q']) {
            uint32_t difference =
                (uint32_t)(int32_t)qu_value -
                (uint32_t)(int32_t)signed_word(state->q_with_unseen_u[state->unseen_counts['u']]);
            state->values[mask] =
                (uint16_t)(state->values[mask] + scaled(difference, draws, total));
        }
        state->values[mask] = (uint16_t)(state->values[mask] + scaled(expected, draws, total));
    }
}

void maven_prepare_leave_table(MavenLeaveTable *state) { prepare(state, NULL, NULL); }
void maven_prepare_search_leave_table(MavenLeaveTable *state, const uint8_t *q_query,
                                      const uint8_t *blank_query) {
    prepare(state, q_query, blank_query);
}
