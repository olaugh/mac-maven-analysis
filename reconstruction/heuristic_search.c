#include "heuristic_search.h"
#include "board_moves.h"
#include "board_state.h"
#include "exchange_candidates.h"
#include "opening_moves.h"
#include "rack_counts.h"
#include "remaining_tiles.h"
#include <string.h>

typedef struct {
    MavenHeuristicSearch *state;
    int phase;
    int16_t new_tiles;
} SearchContext;
static uint32_t read_long(const uint8_t *p) {
    return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3];
}
static void write_long(uint8_t *p, uint32_t x) {
    p[0] = (uint8_t)(x >> 24);
    p[1] = (uint8_t)(x >> 16);
    p[2] = (uint8_t)(x >> 8);
    p[3] = (uint8_t)x;
}
static int16_t signed_word(uint16_t x) {
    return x < 32768 ? (int16_t)x : (int16_t)((int32_t)x - 65536);
}
static int extra(void *user, const uint8_t *move) {
    SearchContext *context = user;
    return maven_accept_word_improvement(context->state->result, move);
}
static int eligible(void *user, const uint8_t *move) {
    SearchContext *context = user;
    return maven_candidate_is_eligible(
        move, context->state->evaluation->application->placement.board, context->new_tiles,
        context->state->word_deduplication ? extra : NULL, context);
}
static void accept(void *user, const uint8_t *move) {
    SearchContext *context = user;
    MavenHeuristicSearch *state = context->state;
    context->new_tiles =
        move[32] ? maven_count_new_move_tiles(move, state->evaluation->application->placement.board)
                 : 0;
    /* CODE37+ea4/eb2 leaves the emitted placement tile count in A5-4e2a,
     * even when a small unseen pool skips the later evaluation pass. */
    if (context->phase == 1)
        state->evaluation->application->new_tiles = context->new_tiles;
    if (state->candidate)
        state->candidate(state->user, context->phase, move);
    /* CODE13+0x82 playing-level gate: every exchange/pass and placement
     * candidate advances the persistent counter and is admitted only if its
     * slot is set; the phase-2 collector rescore (phase 2) is never gated. */
    if (context->phase != 2 && state->level && !maven_level_admit(state->level))
        return;
    maven_insert_ranked_candidate(state->result, move, eligible, context);
}
static int16_t adjusted_letter(void *user, uint8_t letter) {
    SearchContext *context = user;
    MavenLeaveTable *leaves = context->state->leaves;
    uint8_t query[2] = {letter, 0};
    uint32_t *stamp;
    int16_t total = 0;
    const uint8_t *p;
    for (p = leaves->alphabet; *p; ++p)
        total += leaves->unseen_counts[*p];
    return maven_lookup_pattern_with_letter_expectation(
        leaves->patterns, leaves->pattern_count, query, leaves->score_records, &stamp, total,
        leaves->unseen_counts, leaves->distribution, leaves->letter_scores);
}
static uint16_t rack_points(const uint8_t *rack, const uint16_t *values) {
    uint16_t points = 0;
    for (; *rack; ++rack)
        points = (uint16_t)(points + values[*rack]);
    return points;
}
void maven_search_heuristic_moves_shared(MavenHeuristicSearch *state,uint8_t workspace[64]) {
    MavenMoveEvaluation *evaluation = state->evaluation;
    MavenApplyState *application = evaluation->application;
    MavenLetterPlacement *placement = &application->placement;
    MavenScoreInput scoring = {placement->board,
                               placement->values,
                               placement->letter_values,
                               placement->premium_codes,
                               application->letter_multipliers,
                               application->letter_class,
                               application->alphabet,
                               placement->diagnostic,
                               placement->user};
    SearchContext context = {state, 0, 0};
    uint8_t sorted[8], unseen[128] = {0}, finalists[10][34];
    int16_t total, occupied = maven_count_board_bytes(placement->board);
    unsigned count, i;
    const uint8_t *old_sorted = state->leaves->sorted_rack,
                  *old_unseen = state->leaves->unseen_counts;
    maven_count_rack(placement->counts, application->alphabet, evaluation->rack);
    maven_rack_from_counts(sorted, placement->counts, application->alphabet);
    total = maven_count_unseen_tiles(unseen, evaluation->distribution, placement->board,
                                     placement->values, placement->counts, application->alphabet);
    state->leaves->sorted_rack = sorted;
    state->leaves->unseen_counts = unseen;
    maven_prepare_leave_table(state->leaves);
    memset(state->result->moves, 0, sizeof state->result->moves);
    state->result->count = 0;
    application->new_tiles = 0;
    write_long(state->result->moves[0] + 16, UINT32_C(0xf4143e00));
    if (occupied <= 79) {
        MavenExchangeCandidates exchanges = {0};
        exchanges.rack = evaluation->rack;
        exchanges.sorted_rack = sorted;
        exchanges.canonical_masks = state->leaves->canonical_masks;
        exchanges.mask_count = state->leaves->mask_count;
        exchanges.leave_values = state->leaves->values;
        exchanges.leave_offset = state->leave_offset;
        exchanges.unseen_total = total;
        exchanges.opening = !placement->board[144];
        exchanges.opening_score_zero = (uint16_t)evaluation->opening_scores[0];
        exchanges.opening_score_five = (uint16_t)evaluation->opening_scores[5];
        exchanges.adjusted_letter_value = adjusted_letter;
        exchanges.candidate = accept;
        exchanges.diagnostic = placement->diagnostic;
        exchanges.user = &context;
        exchanges.retained_count = &state->result->count;
        maven_generate_exchange_candidates(&exchanges);
    } else if (occupied >= 86) {
        uint8_t pass[34] = {0};
        uint16_t value = (uint16_t)(-rack_points(state->opponent_rack, placement->letter_values) -
                                    2 * rack_points(evaluation->rack, placement->letter_values));
        write_long(pass + 20, (uint32_t)(int32_t)signed_word(value));
        accept(&context, pass);
    }
    context.phase = 1;
    if (!placement->board[144]) {
        MavenOpeningMoves moves = {0};
        moves.enumeration.sections = state->sections;
        memcpy(moves.enumeration.remaining, placement->counts, 128);
        moves.enumeration.vowel_characters = evaluation->vowel_characters;
        moves.enumeration.letter_multipliers = application->letter_multipliers;
        moves.enumeration.word_multipliers = placement->premium_codes;
        moves.scoring = scoring;
        moves.sorted_rack = sorted;
        moves.leave_values = state->leaves->values;
        moves.move = accept;
        moves.user = &context;
        maven_generate_opening_moves(&moves);
    } else {
        MavenBoardMoves moves = {0};
        moves.enumeration.sections = state->sections;
        moves.enumeration.board = placement->board;
        memcpy(moves.enumeration.remaining, placement->counts, 128);
        moves.enumeration.letter_multipliers = application->letter_multipliers;
        moves.enumeration.word_multipliers = placement->premium_codes;
        moves.scoring = scoring;
        moves.sorted_rack = sorted;
        moves.leave_values = state->leaves->values;
        moves.move = accept;
        moves.user = &context;
        if(workspace)maven_generate_board_moves_shared(&moves,5000,NULL,workspace,NULL,0);
        else maven_generate_board_moves_with_controls(&moves, 5000, NULL, state->row_flags);
    }
    if (read_long(state->result->moves[0] + 16) == UINT32_C(0xf4143e00)) {
        write_long(state->result->moves[0] + 16, 0);
    } else if ((uint8_t)total >= 17) {
        memcpy(finalists, state->result->moves, sizeof finalists);
        count = state->result->count;
        state->result->count = 0;
        context.phase = 2;
        for (i = 0; i < count; ++i) {
            uint8_t *move = finalists[i];
            int column,
                first = placement->board[144] ? move[33] : 9 - (int)strlen((const char *)move);
            int last = placement->board[144] ? move[33] : 8;
            for (column = first; column <= last; ++column) {
                MavenMoveEvaluationResult result;
                move[33] = (uint8_t)column;
                result = maven_evaluate_move(move, evaluation, NULL, NULL);
                write_long(move + 24, result.total_bits - read_long(move + 20));
                if (!placement->board[144]) {
                    uint8_t residual[8];
                    MavenScoreScan scan =
                        maven_score_move(move, evaluation->rack, residual, &scoring);
                    write_long(move + 16, scan.score_bits);
                }
                accept(&context, move);
            }
        }
    }
    state->leaves->sorted_rack = old_sorted;
    state->leaves->unseen_counts = old_unseen;
}
void maven_search_heuristic_moves(MavenHeuristicSearch *state){
    maven_search_heuristic_moves_shared(state,NULL);
}
