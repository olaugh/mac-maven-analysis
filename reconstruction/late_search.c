#include "late_search.h"
#include "exchange_candidates.h"
#include "rack_counts.h"
#include "rack_masks.h"
#include "remaining_tiles.h"
#include "undo_move.h"
#include <string.h>
static uint32_t read32(const uint8_t *p) {
    return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3];
}
static uint16_t read16(const uint8_t *p) { return (uint16_t)((uint16_t)p[0] << 8 | p[1]); }
static void write32(uint8_t *p, uint32_t x) {
    p[0] = (uint8_t)(x >> 24);
    p[1] = (uint8_t)(x >> 16);
    p[2] = (uint8_t)(x >> 8);
    p[3] = (uint8_t)x;
}
static int32_t signed32(uint32_t x) {
    return x < UINT32_C(0x80000000) ? (int32_t)x : (int32_t)((int64_t)x - INT64_C(0x100000000));
}
static void checkpoint(MavenLateSearch *s, const char *stage) {
    if (s->checkpoint)
        s->checkpoint(s->user, stage, s);
}
static void own_counts(MavenLateSearch *s) {
    maven_count_rack(s->application->placement.counts, s->application->alphabet, s->own_rack);
}
static void pool_counts(MavenLateSearch *s) {
    maven_count_rack(s->application->placement.counts, s->application->alphabet, s->pool_rack);
}
static void inherited_bytes(uint8_t out[4], const MavenApplyState *app, const uint8_t move[34],
                            const uint8_t used[128]) {
    unsigned i, start = move[32] * 17 + move[33], length = (unsigned)strlen((const char *)move);
    unsigned end = start + length, missing_count = 0;
    uint8_t seen[128] = {0}, missing[2] = {0};
    /* CODE36+059c reads through the A2 left by CODE37's scorer. Its blank
     * arbitration loops sometimes stop before the word ends. This pointer
     * affects duplicate suppression even though it is not an explicit C
     * argument. Reproduce the cursor, not just the chosen blank's square. */
    for (i = 0; i < length; ++i)
        if (!app->placement.board[start + i] && seen[move[i]]++ >= used[move[i]] &&
            missing_count < 2)
            missing[missing_count++] = move[i];
    if ((missing_count == 1 && used[missing[0]]) ||
        (missing_count == 2 && missing[0] != missing[1] && !used[missing[1]]) ||
        (missing_count == 2 && missing[0] == missing[1] && used[missing[0]])) {
        /* CODE37+10ce/+1198/+12f6: stop after the last new occurrence. */
        for (i = 0; i < length; ++i)
            if (!app->placement.board[start + i] && move[i] == missing[0])
                end = start + i + 1;
    } else if (missing_count == 2 && missing[0] == missing[1]) {
        /* CODE37+126a: two identical blanks, no real tile; stop ON the first. */
        for (i = 0; i < length; ++i)
            if (!app->placement.board[start + i] && move[i] == missing[0]) {
                end = start + i;
                break;
            }
    }
    for (i = 0; i < 4; ++i) {
        unsigned offset = end + 61 + i;
        out[i] =
            offset < 544
                ? app->placement.board[offset]
                : (uint8_t)(app->placement.values[(offset - 544) / 2] >> ((offset & 1) ? 0 : 8));
    }
}
static void select_candidate(void *user, const uint8_t move[34]) {
    MavenLateSearch *s = user;
    uint8_t used[128];
    uint16_t count = maven_late_used_tiles(used, move, s->application->placement.board,
                                           s->application->placement.counts);
    s->application->new_tiles = (int16_t)count;
    maven_select_late_pool_reply(&s->baseline, move, count, used);
}
static void merge_candidate(void *user, const uint8_t move[34]) {
    MavenLateSearch *s = user;
    uint8_t used[128], inherited[4];
    uint16_t count = maven_late_used_tiles(used, move, s->application->placement.board,
                                           s->application->placement.counts);
    s->application->new_tiles = (int16_t)count;
    inherited_bytes(inherited, s->application, move, used);
    maven_merge_late_pool_reply(&s->baseline, move, count, used, s->application->placement.board,
                                s->occurrence_masks, s->choose, s->bitmap, inherited);
}
static void refine_candidate(void *user, const uint8_t move[34]) {
    MavenLateSearch *s = user;
    uint8_t used[128];
    uint16_t count = maven_late_used_tiles(used, move, s->application->placement.board,
                                           s->application->placement.counts);
    s->application->new_tiles = (int16_t)count;
    s->value.main_triple = s->last_score.word_multiplier == 3 || s->last_score.word_multiplier == 9;
    maven_refine_late_pool_reply(&s->local, move, count, used, s->application->placement.board,
                                 s->occurrence_masks, s->choose, s->bitmap);
}
static int16_t exchange_letter(void *user, uint8_t letter) {
    MavenLateSearch *s = user;
    MavenLeaveTable *l = s->leaves;
    uint8_t query[2] = {letter, 0};
    uint32_t *stamp;
    return maven_lookup_pattern_with_letter_expectation(
        l->patterns, l->pattern_count, query, l->score_records, &stamp,
        (int16_t)s->baseline.unseen_count, s->unseen_counts, l->distribution, l->letter_scores);
}
static int exchange_eligible(void *user, const uint8_t *move) {
    MavenLateSearch *s = user;
    return maven_candidate_is_eligible(move, s->application->placement.board,
                                       s->application->new_tiles, NULL, NULL);
}
static void exchange_candidate(void *user, const uint8_t move[34]) {
    MavenLateSearch *s = user;
    maven_insert_ranked_candidate(&s->ranking, move, exchange_eligible, s);
}
static uint16_t blank_lookup(void *user) {
    MavenLateSearch *s = user;
    uint32_t *stamp;
    return (uint16_t)maven_lookup_pattern(s->leaves->patterns, s->leaves->pattern_count,
                                          s->blank_query, s->leaves->score_records, &stamp);
}
static void rank_candidate(void *user, const uint8_t raw[34]) {
    MavenLateSearch *s = user;
    uint8_t move[34];
    memcpy(move, raw, 34);
    memcpy(s->value.available, s->application->placement.counts, 128);
    s->value.new_tiles = maven_late_used_tiles(s->value.used, move, s->application->placement.board,
                                               s->value.available);
    s->value.main_triple = s->last_score.word_multiplier == 3 || s->last_score.word_multiplier == 9;
    s->application->new_tiles = (int16_t)s->value.new_tiles;
    (void)maven_rank_late_move(&s->ranker, move);
    memset(s->value.used, 0, 128);
}
static void generate(MavenLateSearch *s, int pool, const uint16_t *anchors,
                     void (*callback)(void *, const uint8_t *),uint8_t *workspace) {
    MavenApplyState *app = s->application;
    MavenLetterPlacement *p = &app->placement;
    MavenBoardMoves moves = {0};
    moves.enumeration.sections = s->sections;
    moves.enumeration.board = p->board;
    moves.enumeration.letter_multipliers = app->letter_multipliers;
    moves.enumeration.word_multipliers = p->premium_codes;
    memcpy(moves.enumeration.remaining, p->counts, 128);
    moves.enumeration.row_anchor_masks = anchors;
    moves.scoring = (MavenScoreInput){p->board,
                                      p->values,
                                      p->letter_values,
                                      p->premium_codes,
                                      app->letter_multipliers,
                                      app->letter_class,
                                      app->alphabet,
                                      p->diagnostic,
                                      p->user};
    moves.sorted_rack = pool ? s->pool_rack : s->own_sorted;
    moves.leave_values = s->leaves->values;
    moves.move = callback;
    moves.user = s;
    if(workspace)
        maven_generate_board_moves_shared(&moves,s->bingo_bonus,&s->last_score,workspace,s->occurrence_masks,pool);
    else if (pool)
        maven_generate_pool_board_moves(&moves, s->bingo_bonus, &s->last_score, s->row_flags,
                                        s->occurrence_masks);
    else
        maven_generate_board_moves_prepared(&moves, s->bingo_bonus, &s->last_score, s->row_flags,
                                            s->occurrence_masks);
}
static void prepare_pool(MavenLateSearch *s, MavenLatePool *pool, uint32_t token) {
    MavenLatePreparation prep = {0};
    prep.pool = pool;
    prep.application = s->application;
    prep.pool_rack = s->pool_rack;
    prep.patterns = s->patterns;
    memcpy(prep.draw_multiplicity, s->draw_multiplicity, sizeof s->draw_multiplicity);
    prep.total_weight = s->draw_multiplicity[0];
    prep.bingo_bonus = s->bingo_bonus;
    prep.serialized_record_base = token;
    maven_prepare_late_pool_replies(&prep);
}
static int add(MavenLateSearch *s, uint16_t mask) {
    return maven_late_add_constraint(&s->constraints, mask, &s->pool_weights, s->unseen_counts,
                                     s->occurrence_masks, s->choose);
}
static void link_rank(MavenLateSearch *s, MavenLatePool *pool, MavenLateRankReply *rank,
                      uint16_t indices[90][182]) {
    unsigned i;
    for (i = 0; i < pool->count; ++i) {
        memcpy(rank[i].record, pool->records[i], 66);
        maven_late_constraint_indices(indices[i], &s->constraints, read16(rank[i].record + 54));
        rank[i].constraints = indices[i];
        rank[i].next = i + 1 < pool->count ? &rank[i + 1] : NULL;
    }
}
static int constraints(MavenLateSearch *s, int local) {
    unsigned i;
    static const unsigned order[4] = {1, 3, 0, 2};
    uint16_t full = (uint16_t)((1u << s->baseline.unseen_count) - 1);
    s->constraints.count = 0;
    if (!add(s, (uint16_t)~full))
        return 0;
    for (i = 0; i < 4; ++i) {
        uint8_t letter = s->baseline.priority_letters[order[i]];
        if (letter && !add(s, (uint16_t) ~(full & s->occurrence_masks[letter][0])))
            return 0;
    }
    for (i = 0; i < s->baseline.count; ++i)
        if ((int8_t)s->baseline.records[i][48] > 0 && !add(s, read16(s->baseline.records[i] + 54)))
            return 0;
    if (local)
        for (i = 0; i < s->local.count; ++i)
            if ((int8_t)s->local.records[i][48] > 0 && !add(s, read16(s->local.records[i] + 54)))
                return 0;
    link_rank(s, &s->baseline, s->baseline_rank, s->baseline_indices);
    if (local)
        link_rank(s, &s->local, s->local_rank, s->local_indices);
    s->ranker.baseline = s->baseline_rank;
    s->ranker.local = local ? s->local_rank : NULL;
    s->ranker.fallback_reply = &s->baseline_rank[s->baseline.count - 1];
    s->ranker.weights = s->constraints.weights;
    s->ranker.weight_count = s->constraints.count;
    return 1;
}
int maven_search_late_game_shared(MavenLateSearch *s,uint8_t workspace[64]) {
    MavenApplyState *app = s->application;
    MavenLetterPlacement *p = &app->placement;
    MavenLeaveTable *leaves = s->leaves;
    uint8_t own_counts_copy[128];
    int16_t total;
    uint16_t scratch[48];
    unsigned i, count, local_passes = 0;
    memcpy(own_counts_copy, p->counts, 128);
    maven_count_rack(own_counts_copy, app->alphabet, s->own_rack);
    total = maven_count_unseen_tiles(s->unseen_counts, leaves->distribution, p->board, p->values,
                                     own_counts_copy, app->alphabet);
    if (total < 8 || total > 16)
        return 0;
    own_counts(s);
    s->baseline.unseen_count = (uint16_t)total;
    memcpy(s->baseline.available, s->unseen_counts, 128);
    memcpy(s->baseline.letter_values, p->letter_values, 256);
    maven_prepare_late_priorities(&s->baseline, s->own_rack, app->alphabet, s->priority_order,
                                  leaves->patterns, leaves->pattern_count, leaves->score_records,
                                  leaves->held_u_query, &s->held_u_value);
    memcpy(p->counts, s->unseen_counts, 128);
    maven_rack_from_counts(s->pool_rack, p->counts, app->alphabet);
    maven_build_occurrence_masks(s->pool_rack, s->occurrence_masks);
    s->baseline.count = 0;
    s->baseline.cutoff_bits = (uint32_t)-200000000;
    maven_prepare_pool_weights(&s->pool_weights, s->unseen_counts, app->alphabet,
                               s->occurrence_masks, s->baseline.distinct_letters, scratch);
    checkpoint(s, "pool_ready");
    generate(s, 1, NULL, select_candidate,workspace);
    checkpoint(s, "pool_selected");
    if (!s->baseline.count)
        return 0;
    for (i = 0; i < s->baseline.count; ++i) {
        memset(s->baseline.records[i] + 50, 0, 4);
        s->baseline.records[i][54] = s->baseline.records[i][55] = 255;
        memset(s->baseline.records[i] + 56, 0, 2);
    }
    memset(s->bitmap, 255, (size_t)1 << total);
    if (!maven_late_merge_anchors(s->anchors, &s->baseline, p->board))
        return 0;
    checkpoint(s, "merge_ready");
    generate(s, 1, s->anchors, merge_candidate,workspace);
    checkpoint(s, "pool_merged");
    for (i = 0; i < 8; ++i) {
        s->ranker.fallback_cache[i][0] = s->ranker.fallback_cache[i][1] = 200000000;
        s->draw_multiplicity[i] = s->choose[total - i][7 - i];
    }
    s->value.unseen_count = (uint16_t)total;
    s->value.own_remaining = s->value.other_remaining = 7;
    s->value.bag_remaining = (uint16_t)(total - 7);
    s->value.unseen_q = s->unseen_counts['q'];
    s->value.held_u_value = s->held_u_value;
    s->value.blank_query = blank_lookup;
    s->value.user = s;
    prepare_pool(s, &s->baseline, s->baseline_token);
    checkpoint(s, "pool_prepared");
    {
        MavenEndgameMoveCache cache = {0};
        cache.first = 0;
        cache.summary_count = s->baseline.count;
        for (i = 0; i < s->baseline.count; ++i) {
            const uint8_t *rec = s->baseline.records[i];
            MavenReplySummary *r = &cache.replies[i];
            r->next = i + 1 < s->baseline.count ? (int16_t)(i + 1) : -1;
            r->score_bits = read32(rec + 4);
            r->emptied_rack = rec[8];
            r->kept_mask = rec[9];
            r->row = rec[10];
            r->column = rec[11];
            r->length = rec[12];
            r->identifier = rec[13];
        }
        maven_build_reply_conflict_map(s->conflict_map, p->board, &cache, s->bit_masks);
    }
    s->conflicts.board = p->board;
    s->conflicts.cell_conflicts = s->conflict_map;
    s->conflicts.bit_masks = s->bit_masks;
    s->ranker.value = &s->value;
    s->ranker.ranking = &s->ranking;
    s->ranker.conflicts = &s->conflicts;
    s->ranker.total_weight = s->draw_multiplicity[0];
    s->ranker.word_deduplication = 0;
    s->ranker.local_cutoff_bits = s->baseline.cutoff_bits;
    if (!constraints(s, 0))
        return 0;
    checkpoint(s, "constraints_ready");
    own_counts(s);
    maven_rack_from_counts(s->own_sorted, p->counts, app->alphabet);
    leaves->sorted_rack = s->own_sorted;
    leaves->unseen_counts = s->unseen_counts;
    /* Both views are A5-4c0c in the original. Pool preparation installed
     * sentinel masks for the synthetic '{' population; leave preparation
     * overwrites only letters in the player's rack. Preserve the other cells
     * instead of restoring a stale copy of the array afterwards. */
    memcpy(leaves->occurrence_masks, s->occurrence_masks, sizeof s->occurrence_masks);
    maven_prepare_search_leave_table(leaves, s->q_query, s->blank_query);
    memcpy(s->occurrence_masks, leaves->occurrence_masks, sizeof s->occurrence_masks);
    memcpy(s->value.leave, leaves->values, 256);
    memcpy(s->value.tile_points, leaves->tile_points, 256);
    memcpy(s->value.letter_leave, s->baseline.letter_leave, 256);
    checkpoint(s, "leaves_ready");
    memset(s->ranking.moves, 0, sizeof s->ranking.moves);
    s->ranking.count = 0;
    memset(s->current_move, 0, 34);
    if (total >= 14) {
        MavenExchangeCandidates exchange = {0};
        uint8_t remaining[8];
        unsigned k;
        exchange.rack = s->own_rack;
        exchange.sorted_rack = s->own_sorted;
        exchange.canonical_masks = leaves->canonical_masks;
        exchange.mask_count = leaves->mask_count;
        exchange.leave_values = leaves->values;
        exchange.leave_offset = s->leave_offset;
        exchange.unseen_total = total;
        exchange.adjusted_letter_value = exchange_letter;
        exchange.candidate = exchange_candidate;
        exchange.diagnostic = p->diagnostic;
        exchange.user = s;
        exchange.retained_count = &s->ranking.count;
        maven_generate_exchange_candidates(&exchange);
        if (!s->ranking.count)
            return 0;
        memcpy(s->current_move, s->ranking.moves[0], 34);
        if (strchr((const char *)s->own_rack, 'q') && !strchr((const char *)s->current_move, 'q')) {
            if (!s->exchange_q_string)
                return 0;
            strcpy((char *)s->current_move + strlen((const char *)s->current_move),
                   (const char *)s->exchange_q_string);
        } else if (strchr((const char *)s->current_move, 'q')) {
            uint8_t *u = (uint8_t *)strchr((const char *)s->current_move, 'u');
            if (u) {
                unsigned n = (unsigned)strlen((const char *)s->current_move);
                *u = s->current_move[n - 1];
                s->current_move[n - 1] = 0;
            }
        }
        maven_rack_from_counts(s->own_rack, p->counts, app->alphabet);
        for (k = 0; s->current_move[k]; ++k)
            --p->counts[s->current_move[k]];
        maven_rack_from_counts(remaining, p->counts, app->alphabet);
        {
            uint16_t mask = maven_find_rack_mask(s->own_rack, remaining, leaves->canonical_masks,
                                                 leaves->mask_count, p->diagnostic, p->user);
            s->current_move[30] = (uint8_t)(mask >> 8);
            s->current_move[31] = (uint8_t)mask;
        }
        maven_count_rack(p->counts, app->alphabet, s->current_move);
        maven_rack_from_counts(s->current_move, p->counts, app->alphabet);
        own_counts(s);
        s->ranking.count = 0;
    } else {
        s->current_move[31] = 127;
        write32(s->current_move + 20, (uint32_t)(int32_t)(int16_t)leaves->values[127]);
    }
    memcpy(s->value.available, p->counts, 128);
    s->value.new_tiles = maven_late_used_tiles(s->value.used, s->current_move, p->board, p->counts);
    s->application->new_tiles = (int16_t)s->value.new_tiles;
    (void)maven_rank_late_move(&s->ranker, s->current_move);
    memset(s->value.used, 0, 128);
    checkpoint(s, "pass_ranked");
    s->ranker.minimum_reply_score_bits = 200000000;
    generate(s, 0, NULL, rank_candidate,workspace);
    checkpoint(s, "own_ranked");
    s->ranker.local_cutoff_bits = s->ranker.minimum_reply_score_bits;
    count = s->ranking.count;
    for (i = 0; i < count; ++i) {
        s->local_index = (uint16_t)i;
        memcpy(s->current_move, s->ranking.moves[i], 34);
        checkpoint(s, "local_begin");
        if (s->current_move[32] &&
            (s->force || i == 0 ||
             signed32(read32(s->current_move + 16) + read32(s->current_move + 24)) >
                 signed32(read32(s->ranking.moves[0] + 16) + read32(s->ranking.moves[0] + 24)))) {
            MavenLocalReplies local = {0};
            MavenApplyState saved;
            uint8_t saved_undo[33];
            MavenMoveUndo undo = {p->board,      p->values, p->undo, &app->row_zero_count,
                                  p->diagnostic, p->user};
            unsigned k;
            {
                int16_t previous_cache[16];
                memcpy(previous_cache, s->local.column_cache, sizeof previous_cache);
                s->local = s->baseline;
                if (local_passes)
                    memcpy(s->local.column_cache, previous_cache, sizeof previous_cache);
            }
            s->local.count = 90;
            s->local.cutoff_bits = s->ranker.local_cutoff_bits;
            /* Global column-cache pointers still address the baseline pool at
             * the first local call, then the reusable local workspace. */
            if (!local_passes)
                for (k = 0; k < 16; ++k)
                    s->local.column_cache[k] = -1;
            ++local_passes;
            memset(s->local.records, 0, sizeof s->local.records);
            for (k = 0; k < 90; ++k) {
                write32(s->local.records[k] + 4, s->ranker.local_cutoff_bits);
                s->local.records[k][54] = s->local.records[k][55] = 255;
                write32(s->local.records[k] + 40, k);
            }
            memset(s->bitmap, 255, (size_t)1 << total);
            pool_counts(s);
            maven_build_occurrence_masks(s->pool_rack, s->occurrence_masks);
            local.last_score = &s->last_score;
            local.application = app;
            local.sections = s->sections;
            local.bit_masks = s->bit_masks;
            local.leave_values = leaves->values;
            local.bingo_bonus = s->bingo_bonus;
            local.row_flags = s->row_flags;
            local.candidate = refine_candidate;
            local.user = s;
            maven_generate_local_replies_shared(&local, s->current_move, s->own_rack, s->pool_rack,
                                              s->pool_rack, s->occurrence_masks,1,workspace);
            own_counts(s);
            maven_apply_move_with_bonus(s->current_move, s->own_rack, app, s->bingo_bonus);
            pool_counts(s);
            saved = *app;
            memcpy(saved_undo, p->undo, 33);
            prepare_pool(s, &s->local, s->local_token);
            *app = saved;
            memcpy(p->undo, saved_undo, 33);
            maven_undo_move(s->own_rack, &undo);
            if (!constraints(s, 1))
                return 0;
            own_counts(s);
            maven_build_occurrence_masks(s->own_sorted, s->occurrence_masks);
        } else
            s->ranker.local = NULL;
        s->ranking.count = (uint16_t)i;
        memcpy(s->value.available, p->counts, 128);
        s->value.new_tiles =
            maven_late_used_tiles(s->value.used, s->current_move, p->board, p->counts);
        s->application->new_tiles = (int16_t)s->value.new_tiles;
        (void)maven_rank_late_move(&s->ranker, s->current_move);
        memset(s->value.used, 0, 128);
        checkpoint(s, "local_finished");
    }
    checkpoint(s, "complete");
    return 1;
}
int maven_search_late_game(MavenLateSearch *s){return maven_search_late_game_shared(s,NULL);}
