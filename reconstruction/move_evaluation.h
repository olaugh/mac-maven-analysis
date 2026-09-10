#ifndef MAVEN_MOVE_EVALUATION_H
#define MAVEN_MOVE_EVALUATION_H
#include "apply_move.h"
#include "letter_expectation.h"
#include "pattern_lookup.h"
#include "pattern_match.h"
#include "premium_exposure.h"
#include "rack_balance.h"

typedef struct {
    MavenApplyState *application;
    uint8_t *rack;
    const uint8_t *distribution;
    const uint8_t *vowel_characters;
    MavenPremiumExposureInput premium;
    MavenRackBalanceCache *balance;
    MavenPatternEntry *lookup_entries;
    int16_t lookup_count;
    MavenPatternMatchInput patterns;
    const uint32_t *opening_scores;    /* Score+24 of length-indexed28-byte records. */
    const uint16_t *small_pool_scores; /*17 words, baseline at index8. */
    const uint16_t *q_with_unseen_u;   /* At least5 words for the standard tile set. */
    const uint16_t *q_without_held_u;  /*7 rows of5 words, indexed draws*5+unseen_u. */
    const uint8_t *unseen_q_query;
    const uint8_t *held_u_query;
    const uint32_t (*letter_scores)[8]; /*27 letters: ? then a..z. */
} MavenMoveEvaluation;
typedef struct {
    uint32_t total_bits;
    size_t record_count;
} MavenMoveEvaluationResult;

/* CODE35[0x36c,0xa48) orchestration using recovered components. Applies the
 * move, evaluates the residual rack/board, then undoes and rebuilds counts.
 * Optional IDs/weights need capacity for pattern record_count+40 including
 * terminator. Table records/cache must already be prepared. Positive unseen
 * total, legal original tile distribution, sorted residual rack and underlying
 * component contracts required. Cache state and scorer/undo globals retain
 * original side effects; board/values/rack are restored. Static recovery,
 * awaiting full original collector replay; individual components have their
 * own narrower validation evidence. */
MavenMoveEvaluationResult maven_evaluate_move(const uint8_t move[34], MavenMoveEvaluation *state,
                                              int16_t *record_ids, int16_t *weights);
#endif
