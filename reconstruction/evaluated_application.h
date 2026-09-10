#ifndef MAVEN_EVALUATED_APPLICATION_H
#define MAVEN_EVALUATED_APPLICATION_H
#include "move_evaluation.h"
#include "evaluation_features.h"
/* CODE31+184, evaluation flag one. The collector, application and feature
 * vector share one initialized engine state. IDs/weights each require the
 * collector's documented pattern_record_count+40 capacity. The remaining
 * workspace preserves its bytes on row-zero moves, as the original does;
 * supply a bounded NUL-terminated value for that path. All underlying legal
 * move and initialized-table contracts apply. Refill/totals are separate. */
MavenMoveEvaluationResult maven_apply_evaluated_move(
    const uint8_t move[34], MavenMoveEvaluation *evaluation, uint32_t features[22],
    int16_t *record_ids, int16_t *record_weights, MavenAppliedMove *workspace);
#endif
