#include "local_replies.h"
#include "board_state.h"
#include "rack_counts.h"
#include "rack_masks.h"
#include "undo_move.h"
#include <string.h>
static int leftmost(const uint8_t board[544], int row, int column, int rack_size) {
    int empty = 0;
    while (column && empty < rack_size) {
        if (!board[row * 17 + column])
            ++empty;
        --column;
    }
    return column + 1;
}
static void mark_range(uint16_t masks[31], int row, int first, int last, const uint32_t bits[32]) {
    masks[row] |= (uint16_t)(~(bits[first] - 1) & (bits[last + 1] - 1));
}
static void mark_before(uint16_t masks[31], const uint8_t board[544], int row, int column,
                        int rack_size, int last, const uint32_t bits[32]) {
    mark_range(masks, row, leftmost(board, row, column, rack_size), last, bits);
}
static void mark_cross(uint16_t masks[31], const uint8_t board[544], int row, int column,
                       int rack_size, const uint32_t bits[32]) {
    int16_t cross_row, cross_column;
    maven_cross_coordinates((int16_t)row, (int16_t)column, &cross_row, &cross_column);
    mark_before(masks, board, cross_row, cross_column, rack_size, cross_column, bits);
}
void maven_local_reply_anchor_masks(uint16_t masks[31], const uint8_t board[544],
                                    const uint8_t move[34], const uint8_t *reply_rack,
                                    const uint32_t bits[32]) {
    int row = move[32], column = move[33], size = (int)strlen((const char *)reply_rack);
    const uint8_t *letter = move;
    if (size > 7)
        size = 7;
    memset(masks, 0, 31 * sizeof *masks);
    mark_before(masks, board, row, column - 1, size, column + (int)strlen((const char *)move),
                bits);
    if (column != 1)
        mark_cross(masks, board, row, column - 1, size, bits);
    while (*letter++) {
        if (!board[row * 17 + column]) {
            int scan = row + 1;
            while (scan != 31 && scan != 16) {
                if (!board[scan * 17 + column]) {
                    mark_before(masks, board, scan, column, size, column, bits);
                    break;
                }
                ++scan;
            }
            if (scan == 31 || scan == 16)
                --scan;
            mark_cross(masks, board, scan, column, size + 2, bits);
            scan = row - 1;
            while (scan && scan != 15) {
                if (!board[scan * 17 + column]) {
                    mark_before(masks, board, scan, column, size, column, bits);
                    break;
                }
                --scan;
            }
        }
        ++column;
    }
    if (column != 16)
        mark_cross(masks, board, row, column, size, bits);
}
typedef struct {
    MavenLocalReplies *state;
    MavenScoreScan score;
} ReplyContext;
static void candidate(void *user, const uint8_t move[34]) {
    ReplyContext *context = user;
    MavenApplyState *app = context->state->application;
    app->new_tiles = context->score.new_tiles;
    if (context->state->last_score)
        *context->state->last_score = context->score;
    context->state->candidate(context->state->user, move);
}
static void generate_local(MavenLocalReplies *s, const uint8_t move[34], uint8_t *own,
                           const uint8_t *other, const uint8_t *prepared_rack,
                           const uint16_t prepared_masks[128][8], int pool,uint8_t *workspace) {
    MavenApplyState *app = s->application;
    MavenLetterPlacement *p = &app->placement;
    MavenBoardMoves moves = {0};
    uint8_t remaining_rack[17];
    uint16_t occurrence_masks[128][8] = {{0}};
    ReplyContext context = {0};
    MavenMoveUndo undo = {p->board,      p->values, p->undo, &app->row_zero_count,
                          p->diagnostic, p->user};
    maven_local_reply_anchor_masks(s->row_masks, p->board, move, other, s->bit_masks);
    maven_count_rack(p->counts, app->alphabet, own);
    maven_apply_move_with_bonus(move, own, app, s->bingo_bonus);
    maven_count_rack(p->counts, app->alphabet, other);
    maven_rack_from_counts(remaining_rack, p->counts, app->alphabet);
    if (prepared_masks)
        memcpy(occurrence_masks, prepared_masks, sizeof occurrence_masks);
    else
        maven_build_occurrence_masks(prepared_rack, occurrence_masks);
    if (s->ready)
        s->ready(s->user);
    moves.enumeration.sections = s->sections;
    moves.enumeration.board = p->board;
    moves.enumeration.letter_multipliers = app->letter_multipliers;
    moves.enumeration.word_multipliers = p->premium_codes;
    memcpy(moves.enumeration.remaining, p->counts, 128);
    moves.enumeration.row_anchor_masks = s->row_masks;
    moves.scoring = (MavenScoreInput){p->board,
                                      p->values,
                                      p->letter_values,
                                      p->premium_codes,
                                      app->letter_multipliers,
                                      app->letter_class,
                                      app->alphabet,
                                      p->diagnostic,
                                      p->user};
    moves.sorted_rack = remaining_rack;
    moves.leave_values = s->leave_values;
    moves.move = candidate;
    moves.user = &context;
    context.state = s;
    if(workspace)
        maven_generate_board_moves_shared(&moves,s->bingo_bonus,&context.score,workspace,occurrence_masks,pool);
    else if (pool)
        maven_generate_pool_board_moves(&moves, s->bingo_bonus, &context.score, s->row_flags,
                                        occurrence_masks);
    else
        maven_generate_board_moves_prepared(&moves, s->bingo_bonus, &context.score, s->row_flags,
                                            occurrence_masks);
    maven_undo_move(own, &undo);
}

void maven_generate_local_replies(MavenLocalReplies *s, const uint8_t move[34], uint8_t *own,
                                  const uint8_t *other) {
    generate_local(s, move, own, other, s->sorted_rack, NULL, 0,NULL);
}
void maven_generate_local_pool_replies(MavenLocalReplies *s, const uint8_t move[34], uint8_t *own,
                                       const uint8_t *other, const uint8_t *prepared_rack,
                                       const uint16_t occurrences[128][8]) {
    generate_local(s, move, own, other, prepared_rack, occurrences, 1,NULL);
}
void maven_generate_local_replies_shared(MavenLocalReplies *s,const uint8_t move[34],uint8_t *own,
    const uint8_t *other,const uint8_t *prepared_rack,const uint16_t occurrences[128][8],
    int pool,uint8_t workspace[64]){
    generate_local(s,move,own,other,prepared_rack,occurrences,pool,workspace);
}
