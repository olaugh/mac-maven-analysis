#ifndef MAVEN_ADJUSTED_PATTERN_LOOKUP_H
#define MAVEN_ADJUSTED_PATTERN_LOOKUP_H
#include "pattern_lookup.h"
/* CODE32 [0x164c,0x16c0). The original lookup lazily constructs its cache;
 * this adapter requires the already-prepared cache from pattern_cache.c.
 * Single-letter results add the current-pool expectation and subtract the
 *96-tile baseline using distribution[letter]-1. Multi-letter/empty queries
 * do not access count or expectation tables. Signed-byte count semantics,
 * expectation-domain constraints, ASCII a..z/? and table bounds apply.
 * The accumulator pointer reflects the base lookup only: an absent single
 * letter can still produce a nonzero adjusted score with a NULL pointer. */
int16_t maven_lookup_pattern_with_letter_expectation(
    MavenPatternEntry *entries, int16_t count, const uint8_t *letters, const uint8_t *score_records,
    uint32_t **accumulator, int16_t unseen_total, const uint8_t unseen_counts[128],
    const uint8_t distribution[128], const uint32_t letter_scores[27][8]);
#endif
