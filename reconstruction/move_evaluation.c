#include "move_evaluation.h"
#include "rack_counts.h"
#include "remaining_tiles.h"
#include "undo_move.h"
#include <string.h>

typedef struct {
    MavenMoveEvaluationResult result;
    int16_t *ids, *weights;
} Contributions;
static int16_t signed_word(uint16_t value) {
    return value < 32768 ? (int16_t)value : (int16_t)((int32_t)value - 65536);
}
static int16_t signed_byte(uint8_t value) { return value < 128 ? value : (int16_t)value - 256; }
static int64_t signed_long(uint32_t value) {
    return value <= INT32_MAX ? value : (int64_t)value - INT64_C(4294967296);
}
static void contribute(Contributions *output, int16_t id, uint32_t value) {
    size_t index = output->result.record_count++;
    output->result.total_bits += value;
    if (output->ids)
        output->ids[index] = id;
    if (output->weights)
        output->weights[index] = signed_word((uint16_t)value);
}
static int16_t lookup(MavenMoveEvaluation *state, const uint8_t *text) {
    uint32_t *accumulator;
    return maven_lookup_pattern(state->lookup_entries, state->lookup_count, text,
                                state->patterns.score_records, &accumulator);
}
static uint32_t scale_expected(uint32_t value, int16_t draws, int16_t total) {
    value *= (uint32_t)(int32_t)draws;
    value += (uint32_t)(int32_t)(total / 2);
    return (uint32_t)(signed_long(value) / total);
}
MavenMoveEvaluationResult maven_evaluate_move(const uint8_t move[34], MavenMoveEvaluation *state,
                                              int16_t *record_ids, int16_t *weights) {
    MavenApplyState *application = state->application;
    MavenLetterPlacement *placement = &application->placement;
    const uint8_t *alphabet = application->alphabet, *letter;
    uint8_t unseen[128] = {0};
    int16_t total, pool_vowels = 0, pool_consonants;
    int16_t held_vowels = 0, held_consonants = 0, blanks = 0, draws, residual_draws;
    uint32_t value;
    Contributions output = {{0, 0}, record_ids, weights};
    MavenPatternMatchInput patterns = state->patterns;
    MavenMoveUndo undo = {placement->board,      placement->values,
                          placement->undo,       &application->row_zero_count,
                          placement->diagnostic, placement->user};

    maven_count_rack(placement->counts, alphabet, state->rack);
    total = signed_byte((uint8_t)maven_count_unseen_tiles(unseen, state->distribution,
                                                          placement->board, placement->values,
                                                          placement->counts, alphabet));
    if (!placement->board[8 * 17 + 8])
        contribute(&output, -32, state->opening_scores[move[32] ? strlen((const char *)move) : 0]);
    value = maven_adjacent_premium_penalty(move, &state->premium);
    if (value)
        contribute(&output, 20000, value);
    maven_apply_move_without_evaluation(move, state->rack, application);

    for (letter = (const uint8_t *)"aeiou"; *letter; ++letter)
        pool_vowels += signed_byte(unseen[*letter]);
    pool_consonants = total - pool_vowels;
    if (4 * total > 10 * pool_vowels) {
        pool_vowels += signed_byte(unseen['?']);
        pool_consonants -= signed_byte(unseen['?']);
    }
    for (letter = state->rack; *letter; ++letter) {
        if (strchr((const char *)state->vowel_characters, *letter))
            ++held_vowels;
        else if (*letter == '?')
            ++blanks;
        else
            ++held_consonants;
    }
    draws = 7 - held_vowels - held_consonants - blanks;
    if (draws > total - 7)
        draws = total > 7 ? total - 7 : 0;
    contribute(&output, -1,
               maven_rack_balance_with_blanks(state->balance, held_vowels, held_consonants, blanks,
                                              pool_vowels, pool_consonants, draws));
    {
        int16_t after_draw = move[32] ? total - draws : total;
        if (after_draw > 7 && after_draw < 17)
            contribute(
                &output, -33,
                (uint32_t)(int32_t)signed_word((uint16_t)(state->small_pool_scores[after_draw] -
                                                          state->small_pool_scores[8])));
    }
    value = 0;
    for (letter = alphabet; *letter; ++letter) {
        uint8_t query[2] = {*letter, 0};
        if (signed_byte(unseen[*letter]) < 0)
            placement->diagnostic(placement->user);
        if (unseen[*letter] && *letter != 'q') {
            int32_t product = lookup(state, query) * signed_byte(unseen[*letter]);
            value += (uint32_t)(int32_t)signed_word((uint16_t)product);
        }
    }
    if (unseen['q'])
        value += (uint32_t)(int32_t)signed_word(state->q_with_unseen_u[unseen['u']]) +
                 (uint32_t)(int32_t)lookup(state, state->unseen_q_query);
    residual_draws = 7 - (int16_t)strlen((const char *)state->rack);
    contribute(&output, -2, scale_expected(value, residual_draws, total));
    if (strchr((const char *)state->rack, 'u') && unseen['q']) {
        int16_t delta = signed_word((uint16_t)((uint16_t)lookup(state, state->held_u_query) -
                                               state->q_with_unseen_u[unseen['u']]));
        contribute(&output, -3, scale_expected((uint32_t)(int32_t)delta, residual_draws, total));
    }
    if (strchr((const char *)state->rack, 'q') && !strchr((const char *)state->rack, 'u'))
        contribute(&output, -4,
                   (uint32_t)(int32_t)signed_word(
                       state->q_without_held_u[residual_draws * 5 + unseen['u']]));
    for (letter = state->rack; *letter; ++letter) {
        const uint8_t *in_alphabet;
        unsigned index;
        if (*letter == letter[1])
            continue;
        index = *letter == '?' ? 0 : (unsigned)(*letter - 'a' + 1);
        value = maven_letter_expectation(total, signed_byte(unseen[*letter]),
                                         state->letter_scores[index]);
        value -= maven_letter_expectation(96, signed_byte(state->distribution[*letter]) - 1,
                                          state->letter_scores[index]);
        in_alphabet = (const uint8_t *)strchr((const char *)alphabet, *letter);
        contribute(&output, (int16_t)(-5 - (in_alphabet - alphabet)), value);
    }
    patterns.board = placement->board;
    patterns.values = placement->values;
    patterns.rack_counts = placement->counts;
    {
        MavenPatternMatchResult matched = maven_match_patterns(
            &patterns, 0, record_ids ? record_ids + output.result.record_count : NULL,
            weights ? weights + output.result.record_count : NULL);
        output.result.total_bits += matched.total_bits;
        output.result.record_count += matched.count;
    }
    for (letter = state->rack; *letter; ++letter)
        if (signed_byte(placement->counts[*letter]) <= 0)
            placement->diagnostic(placement->user);
    maven_undo_move(state->rack, &undo);
    maven_count_rack(placement->counts, alphabet, state->rack);
    return output.result;
}
