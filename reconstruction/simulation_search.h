#ifndef MAVEN_SIMULATION_SEARCH_H
#define MAVEN_SIMULATION_SEARCH_H
#include "rollout_search.h"
#include <stdint.h>

/* CODE3+f6c candidate initialization after the caller's zeroed config. Copies
 * up to64 raw moves, seeds each accumulated score with its three-term rank,
 * and leaves win/sample counters zero. That is a deliberate original prior:
 * the first rollout is added to this seed without incrementing its weight.
 * Source and destination must not overlap. Returns the capped count. */
unsigned maven_seed_simulation_candidates(uint8_t entries[64 * 46], const uint8_t *moves,
                                          unsigned count);
/* CODE3+280..294: positive signed-word lookahead is doubled into reply plies;
 * nonpositive input becomes one first. The shift retains original16-bit wrap.
 * Modern callers should reject negative results before starting a batch. */
int16_t maven_simulation_reply_plies(int16_t lookahead);

typedef struct {
    MavenRolloutSearch *rollout;
    const uint8_t *distribution;
    const uint16_t (*choose)[8]; /* Eighteen original binomial rows. */
    uint8_t ranked[64][34];
    uint32_t batches, total_weight;
    /* CODE3+4 publishes the current averaged ranking before each batch and
     * after exhaustive enumeration. This callback observes computed records;
     * it must not mutate engine state or supply ranking outcomes. */
    void (*publish)(void *, const uint8_t *, unsigned);
    void *user;
} MavenExhaustiveSimulation;

/* Computational exhaustive path of CODE3+c58 -> CODE38+46 -> CODE3+2c6.
 * Uses the current player's rack to derive unseen counts, enumerates every
 * seven-tile multiset, computes every rollout and final averaged ranking.
 * Requires legal position,7..17 unseen tiles, <=64 supplied candidate records,
 * original table/dictionary contracts and initialized rollout callbacks.
 * Returns0 for unsupported dimensions or a cancelled batch. Cancellation leaves
 * partial batch state for the caller; use simulation_session for restoration.
 * No heap allocation or Toolbox calls.
 * UI/log callbacks, nonlocal unwinding, random infinite sampling, and the
 * CODE3+dd6 post-session leave-cache rebuild are outside this function.
 * Board and rack restoration follows the batch routine; scorer, cache and
 * random state continue across all batches. Original trace acceptance is
 * recorded separately from static source-range association. */
int maven_simulate_all_opponent_racks(MavenExhaustiveSimulation *state);
#endif
