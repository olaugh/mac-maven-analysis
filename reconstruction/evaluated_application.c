#include "evaluated_application.h"
#include "board_state.h"
#include <string.h>
static int16_t vowel(void *user, int16_t letter) {
    MavenMoveEvaluation *e = user;
    return letter != 0 && strchr((const char *)e->vowel_characters, letter) != 0;
}
static int16_t matches(void *user, int16_t id) {
    MavenMoveEvaluation *e = user;
    return maven_evaluation_record_flag_clear(e->patterns.records, e->patterns.record_count, id);
}
MavenMoveEvaluationResult maven_apply_evaluated_move(
    const uint8_t move[34], MavenMoveEvaluation *e, uint32_t features[22],
    int16_t *ids, int16_t *weights, MavenAppliedMove *workspace) {
    MavenApplyState *app = e->application;
    MavenMoveEvaluationResult result;
    MavenEvaluationBefore before;
    int16_t occupied;
    uint32_t score = ((uint32_t)move[16] << 24) | ((uint32_t)move[17] << 16) |
                     ((uint32_t)move[18] << 8) | move[19];
    app->placement.undo[0] = move[32];
    result = maven_evaluate_move(move, e, ids, weights);
    before = maven_prepare_evaluation_features(features, app->placement.counts,
                                               (uint32_t)strlen((const char *)e->rack), vowel, e);
    occupied = maven_count_board_bytes(app->placement.board);
    maven_apply_move_with_details(move, e->rack, app, 5000, workspace);
    if (!move[32]) features[MAVEN_FEATURE_ROW_ZERO] = 1;
    maven_finish_evaluation_features(features, &before, app->placement.counts, score,
                                      occupied, workspace->remaining, workspace->special_score,
                                      (const uint16_t *)ids, (const uint16_t *)weights, matches, e);
    return result;
}
