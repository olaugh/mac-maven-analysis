#ifndef MAVEN_SIMULATION_SESSION_H
#define MAVEN_SIMULATION_SESSION_H
#include "simulation_search.h"
#include "simulation_restore.h"
#include "leave_table.h"
#include "random_opponent.h"
typedef enum {
    MAVEN_SIMULATION_IDLE, MAVEN_SIMULATION_RUNNING, MAVEN_SIMULATION_EXHAUSTED,
    MAVEN_SIMULATION_LIMIT, MAVEN_SIMULATION_CANCELLED, MAVEN_SIMULATION_ERROR
} MavenSimulationStatus;
typedef struct {
    MavenRolloutSearch *rollout;
    MavenLeaveTable *leaves;
    const uint8_t *distribution;
    const uint16_t (*choose)[8];
    MavenRefillOps random;
    uint32_t (*stack_ticks)(void *);
    void *clock_user;
    uint32_t limit_bits;
    void (*publish)(void *, const uint8_t *, unsigned);
    void (*checkpoint)(void *, const char *);
    void *user;
    MavenSimulationSnapshot saved;
    MavenSimulationStatus status;
    uint8_t sample[8], bag[128], sorted_rack[8], unseen[128], ranked[64][34];
    uint32_t batches, total_weight;
} MavenSimulationSession;
/* Computational session lifecycle: caller supplies initialized engine/tables
 * and seeded46-byte candidate records. No captured outcome is an input.
 * Begin snapshots the position; finish restores it and rebuilds selected-rack
 * leaves. Buffers belong to the session, which must outlive these pointers.
 * Step samples one random opponent and runs one complete batch. Exhaustive
 * mode computes all opponent multisets and final publication before cleanup.
 * Cancellation is accepted at explicit reply polls and restores the session
 * while preserving original partial-candidate counters. Interrupting a selector
 * internally still needs explicit unwinding and is not modeled here.
 */
int maven_begin_simulation_session(MavenSimulationSession *);
MavenSimulationStatus maven_step_simulation_session(MavenSimulationSession *);
MavenSimulationStatus maven_run_exhaustive_session(MavenSimulationSession *);
MavenSimulationStatus maven_finish_simulation_session(MavenSimulationSession *, MavenSimulationStatus);
#endif
