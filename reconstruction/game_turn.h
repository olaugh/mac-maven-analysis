#ifndef MAVEN_GAME_TURN_H
#define MAVEN_GAME_TURN_H
#include "evaluated_application.h"
#include "display_move_score.h"
#include "rack_refill.h"
/* Engine-level turn state. Tables/cache and legal move are prepared inputs;
 * this is not the public untrusted-input boundary. The append callback must
 * copy its temporary payload synchronously. Its failure prevents scoring or
 * placement, although rack canonicalization has already occurred. */
typedef struct {
    MavenMoveEvaluation *evaluation;
    uint8_t *racks[2];
    uint32_t totals[2],statistics[2][22],features[22];
    unsigned selected_side;
    int phase; /* CODE11:2 opponent,3 human-ready,4 end-processing. */
    const uint8_t *display_order;
    MavenDisplayMoveScore *display_score; /* Human commit; NULL for headless. */
    MavenRefillOps refill;
    uint32_t initial_stack_ticks;
    uint8_t bag[128];
    uint32_t bag_length;
    MavenMoveEvaluationResult evaluation_result;
    uint16_t canonical_masks[128],tile_points[128],occurrence_masks[128][8];
    unsigned mask_count;
    void *history_user;
    int (*append)(void *,int tag,const uint8_t *payload,size_t length);
} MavenGameTurn;
/* CODE11 human/computer commit once a move has been selected. Includes
 * computed collector, statistics, totals, actual refill and next-side/end
 * decision. Excludes UI drawing and computer move selection. Returns0 on
 * history failure,1 on success. ids/weights and workspace follow the
 * evaluated-application capacity contracts. */
int maven_commit_game_turn(MavenGameTurn *game,const uint8_t move[34],
    int16_t *ids,int16_t *weights,MavenAppliedMove *workspace);
/* CODE7+3a4 and CODE11 end transition. Apply the original doubled opponent
 * rack credit on going out, or subtract each rack if both remain. Appends
 * two tag3 records in original selected-side order. Caller must ensure an
 * end condition and reserve history capacity first: append failure can leave
 * totals/statistics and the first record committed. */
int maven_finish_game(MavenGameTurn *game);
#endif
