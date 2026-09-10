#include "endgame_generation.h"
#include "rack_counts.h"
#include "rack_masks.h"
#include <string.h>
typedef struct {
    MavenEndgameGeneration *state;
    MavenScoreScan score;
    int side;
} GenerationContext;
static void candidate(void *user, const uint8_t move[34]) {
    GenerationContext *context = user;
    MavenEndgameGeneration *s = context->state;
    MavenApplyState *app = s->application;
    uint8_t copy[34];
    app->new_tiles = context->score.new_tiles;
    if (s->candidate)
        s->candidate(s->user, context->side, move);
    if (!maven_candidate_is_eligible(move, app->placement.board, context->score.new_tiles, NULL,
                                     NULL))
        return;
    if (context->side) {
        memcpy(copy, move, 34);
        maven_cache_opponent_endgame_move(&s->cache, &s->ranking, copy);
    } else
        maven_cache_own_endgame_move(&s->cache, &s->ranking, move);
}
void maven_prepare_endgame_rack(MavenEndgameGeneration *s, const uint8_t *rack) {
    MavenApplyState *app = s->application;
    MavenLetterPlacement *placement = &app->placement;
    maven_count_rack(placement->counts, app->alphabet, rack);
    maven_rack_from_counts(s->sorted_rack, placement->counts, app->alphabet);
    s->mask_count =
        maven_prepare_canonical_rack_masks(s->sorted_rack, placement->letter_values,
                                           s->canonical_masks, s->tile_points, s->occurrence_masks);
    s->ranking.count = 0;
    memset(s->ranking.moves, 0, sizeof s->ranking.moves);
    memset(s->cache.best, 0, sizeof s->cache.best);
    memset(s->cache.second, 0, sizeof s->cache.second);
}
static void prepare_side(MavenEndgameGeneration *s, const uint8_t *rack, int side,uint8_t *workspace) {
    MavenApplyState *app = s->application;
    MavenLetterPlacement *placement = &app->placement;
    MavenBoardMoves moves = {0};
    GenerationContext context = {0};
    uint16_t leaves[128] = {0};
    unsigned i;
    maven_prepare_endgame_rack(s, rack);
    if (side) {
        memset(s->cache.replies, 0, 256 * sizeof s->cache.replies[0]);
        for (i = 0; i < 256; ++i)
            s->cache.replies[i].next = -1;
    }
    moves.enumeration.sections = s->sections;
    moves.enumeration.board = placement->board;
    moves.enumeration.letter_multipliers = app->letter_multipliers;
    moves.enumeration.word_multipliers = placement->premium_codes;
    memcpy(moves.enumeration.remaining, placement->counts, 128);
    moves.scoring = (MavenScoreInput){placement->board,
                                      placement->values,
                                      placement->letter_values,
                                      placement->premium_codes,
                                      app->letter_multipliers,
                                      app->letter_class,
                                      app->alphabet,
                                      placement->diagnostic,
                                      placement->user};
    moves.sorted_rack = s->sorted_rack;
    moves.leave_values = leaves;
    moves.move = candidate;
    moves.user = &context;
    context.state = s;
    context.side = side;
    if(workspace)maven_generate_board_moves_shared(&moves,s->bingo_bonus,&context.score,workspace,NULL,0);
    else maven_generate_board_moves_with_controls(&moves, s->bingo_bonus, &context.score, s->row_flags);
}
static void prepare_tables(MavenEndgameGeneration *s, int side) {
    MavenLetterPlacement *placement = &s->application->placement;
    maven_prepare_endgame_mask_scores(s->cache.best, s->cache.second, s->sorted_rack,
                                      s->canonical_masks, s->mask_count, s->tile_points,
                                      placement->letter_values, s->occurrence_masks,
                                      placement->diagnostic, placement->user);
    maven_prepare_endgame_rack_bounds(s->tables[side][0], s->tables[side][1], s->tables[side][2],
                                      s->sorted_rack, s->canonical_masks, s->mask_count,
                                      s->tile_points, s->cache.best, s->cache.second,
                                      placement->diagnostic, placement->user);
}
unsigned maven_prepare_endgame_candidates_shared(MavenEndgameGeneration *s, const uint8_t *own,
                                          const uint8_t *other, uint8_t output[10][34],uint8_t workspace[64]) {
    unsigned count;
    prepare_side(s, own, 0,workspace);
    memcpy(output, s->ranking.moves, 340);
    count = s->ranking.count;
    prepare_tables(s, 0);
    prepare_side(s, other, 1,workspace);
    prepare_tables(s, 1);
    maven_link_reply_summaries(&s->cache, &s->ranking);
    maven_build_reply_conflict_map(s->conflicts, s->application->placement.board, &s->cache,
                                   s->bit_masks);
    return count;
}

unsigned maven_prepare_endgame_candidates(MavenEndgameGeneration *s,const uint8_t *own,const uint8_t *other,uint8_t output[10][34]){return maven_prepare_endgame_candidates_shared(s,own,other,output,NULL);}
