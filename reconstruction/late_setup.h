#ifndef MAVEN_LATE_SETUP_H
#define MAVEN_LATE_SETUP_H
#include "late_pool_select.h"
#include "pattern_lookup.h"
#include "pool_weights.h"
/* CODE36+189a..1af0. Preserves unused array cells; query cache is caller-owned. */
void maven_prepare_late_priorities(MavenLatePool *, const uint8_t *own_rack,
                                   const uint8_t *alphabet, const uint8_t *priority_order,
                                   MavenPatternEntry *, int16_t pattern_count,
                                   const uint8_t *score_records, const uint8_t *held_u_query,
                                   uint16_t *held_u_value);
/* CODE36+1bbe..1ca6: first eligible anchor in each selected reply's span. */
int maven_late_merge_anchors(uint16_t anchors[31], const MavenLatePool *, const uint8_t board[544]);
/* CODE36+1642: reconstruct used tiles, taking blanks only after real copies. */
uint16_t maven_late_used_tiles(uint8_t used[128], const uint8_t move[34], const uint8_t board[544],
                               const uint8_t available[128]);
typedef struct {
    uint16_t masks[182], weights[182], count;
} MavenLateConstraints;
/* CODE36+1714. Duplicate insertion writes the spare mask slot but no weight. */
int maven_late_add_constraint(MavenLateConstraints *, uint16_t mask, const MavenPoolWeights *,
                              uint8_t counts[128], const uint16_t occurrences[128][8],
                              const uint16_t choose[][8]);
/* CODE36+17c6: returns number of indices written, including the zero terminator.
 * Caller supplies at least constraints.count words. */
uint16_t maven_late_constraint_indices(uint16_t *, const MavenLateConstraints *, uint16_t required);
#endif
