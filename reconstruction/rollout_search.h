#ifndef MAVEN_ROLLOUT_SEARCH_H
#define MAVEN_ROLLOUT_SEARCH_H
#include "apply_move.h"
#include <stddef.h>
#include <stdint.h>
typedef enum {
    MAVEN_ROLLOUT_CANDIDATE_APPLIED,
    MAVEN_ROLLOUT_CANDIDATE_REFILLED,
    MAVEN_ROLLOUT_REPLY_SELECTED,
    MAVEN_ROLLOUT_REPLY_APPLIED,
    MAVEN_ROLLOUT_REPLY_REFILLED,
    MAVEN_ROLLOUT_CANDIDATE_RESTORED
} MavenRolloutEvent;
typedef struct {
    MavenApplyState *application;
    uint8_t *racks[2]; /* Mutable8-byte buffers; player0 owns the candidate list. */
    uint8_t *entries;  /* count original46-byte records. */
    uint16_t count;
    int16_t reply_plies;
    int selected_side;
    uint8_t selected_move[34];
    /* Selector corresponds to CODE3+1de, including selected-rack counts and
     * best-move output. Refill corresponds to CODE31+7e0 (including row0 clear).
     * The callbacks may update evaluator/cache state as the original does. */
    void (*select)(void *, int side, uint8_t move[34]);
    void (*refill)(void *, int side);
    void (*observe)(void *, MavenRolloutEvent, unsigned candidate, unsigned reply);
    void (*poll)(void *);
    void *user;
    /* Checked after each explicit reply poll (CODE3+0500). */
    int (*cancelled)(void *);
} MavenRolloutSearch;

/* CODE3[0x2c6,0x66a), computational complete-batch path. Evaluates every
 * candidate against the SAME supplied opponent sample, with its multiplicity
 * weight. Applies candidate, refills, alternates replies, adds terminal/rack
 * adjustments, then accumulates weighted spread/win units/sample count.
 * Board/value arrays and both rack strings are restored; count/undo/scorer
 * globals and selector/cache/random state retain original side effects.
 * UI and log windows are excluded. Use the checked API when cancellation is enabled.
 * Valid legal racks/moves, <=64 candidates and nonnegative reply_plies required.
 * Raw records use BE32 sums at+34, twice-win units+38 and weight count+42. */
void maven_run_rollout_batch(MavenRolloutSearch *state, const uint8_t *opponent_sample,
                             uint32_t weight);
/* Returns 0 when a reply poll cancels, 1 after the complete batch. On cancel,
 * the current candidate weight has advanced but spread/win totals have not.
 * Position remains at the interruption boundary for outer session restoration.
 * This does not interrupt a selector internally. */
int maven_run_rollout_batch_checked(MavenRolloutSearch *, const uint8_t *, uint32_t);
#endif
