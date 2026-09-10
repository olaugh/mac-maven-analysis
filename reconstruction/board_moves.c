#include "board_moves.h"
#include "rack_masks.h"
#include <string.h>

typedef struct {
    MavenBoardMoves *state;
    uint32_t bonus;
    MavenScoreScan *last_score;
    const uint8_t *row_flags;
    uint16_t occurrence_masks[128][8];
    uint8_t scratch_move[34];
    int pool;
    uint8_t *workspace;
    int main_control;
} BoardContext;
static void row_ready(void *user,unsigned row){
    BoardContext *context=user;
    context->main_control=context->workspace[32+row]!=0;
}
static void write_long(uint8_t *p, uint32_t value) {
    p[0] = (uint8_t)(value >> 24);
    p[1] = (uint8_t)(value >> 16);
    p[2] = (uint8_t)(value >> 8);
    p[3] = (uint8_t)value;
}
static void evaluate(void *user, const MavenBoardPlacement *placement, const uint8_t *remaining) {
    BoardContext *context = user;
    MavenBoardMoves *state = context->state;
    uint8_t *move = context->scratch_move, residual[17], used[128] = {0};
    uint16_t mask = UINT16_MAX;
    size_t i, consumed_count = 0;
    const uint8_t *board = state->enumeration.board + placement->row * 17 + placement->column;
    MavenScoreScan score;
    (void)remaining;
    if (maven_counted_sections_contain(state->enumeration.sections, placement->section,
                                       placement->word))
        return;
    memcpy(move, placement->word, 16);
    move[32] = placement->row;
    move[33] = placement->column;
    score = (context->pool ? maven_score_pool_move : maven_score_move_with_main_control)(
        move, state->sorted_rack, residual, &state->scoring, context->bonus,
        context->workspace ? context->main_control :
        (context->row_flags && context->row_flags[placement->row]));
    for (i = 0; placement->word[i]; ++i) {
        uint8_t letter = placement->word[i];
        if (board[i])
            continue;
        if (used[letter] == state->enumeration.remaining[letter])
            letter = '?';
        mask &= context->occurrence_masks[letter][used[letter]++];
        ++consumed_count;
    }
    if (context->last_score)
        *context->last_score = score;
    write_long(move + 16, score.score_bits);
    if (mask < 128)
        write_long(move + 20, state->leave_values[mask] < 32768
                                  ? state->leave_values[mask]
                                  : UINT32_C(0xffff0000) | state->leave_values[mask]);
    i = strlen((const char *)state->sorted_rack);
    move[29] = consumed_count == (i > 7 ? 7 : i);
    move[30] = (uint8_t)(mask >> 8);
    move[31] = (uint8_t)mask;
    state->move(state->user, move);
}
static void generate_prepared(MavenBoardMoves *state, uint32_t bonus, MavenScoreScan *last_score,
                              const uint8_t *row_flags, const uint16_t occurrence_masks[128][8],
                              int pool,uint8_t *workspace) {
    BoardContext context;
    MavenBoardEnumeration enumeration = state->enumeration;
    memset(&context, 0, sizeof context);
    context.state = state;
    context.pool = pool;
    context.bonus = bonus;
    context.last_score = last_score;
    context.row_flags = row_flags;
    context.workspace=workspace;
    if (occurrence_masks)
        memcpy(context.occurrence_masks, occurrence_masks, sizeof context.occurrence_masks);
    else
        maven_build_occurrence_masks(state->sorted_rack, context.occurrence_masks);
    enumeration.placement = evaluate;
    enumeration.user = &context;
    maven_enumerate_board_placements_shared(&enumeration,workspace,
        workspace?row_ready:NULL,&context,NULL,NULL);
}

void maven_generate_board_moves(MavenBoardMoves *state) {
    maven_generate_board_moves_with_bonus(state, 5000);
}

void maven_generate_board_moves_with_bonus(MavenBoardMoves *state, uint32_t bonus) {
    maven_generate_board_moves_with_score(state, bonus, NULL);
}

void maven_generate_board_moves_with_score(MavenBoardMoves *state, uint32_t bonus,
                                           MavenScoreScan *last_score) {
    maven_generate_board_moves_with_controls(state, bonus, last_score, NULL);
}

void maven_generate_board_moves_with_controls(MavenBoardMoves *state, uint32_t bonus,
                                              MavenScoreScan *last_score,
                                              const uint8_t *row_flags) {
    maven_generate_board_moves_prepared(state, bonus, last_score, row_flags, NULL);
}

void maven_generate_board_moves_prepared(MavenBoardMoves *state, uint32_t bonus,
                                         MavenScoreScan *last_score, const uint8_t *row_flags,
                                         const uint16_t occurrences[128][8]) {
    generate_prepared(state, bonus, last_score, row_flags, occurrences, 0,NULL);
}
void maven_generate_pool_board_moves(MavenBoardMoves *state, uint32_t bonus,
                                     MavenScoreScan *last_score, const uint8_t *row_flags,
                                     const uint16_t occurrences[128][8]) {
    generate_prepared(state, bonus, last_score, row_flags, occurrences, 1,NULL);
}
void maven_generate_board_moves_shared(MavenBoardMoves *state,uint32_t bonus,MavenScoreScan *score,
    uint8_t workspace[64],const uint16_t occurrences[128][8],int pool){
    generate_prepared(state,bonus,score,NULL,occurrences,pool,workspace);
}
