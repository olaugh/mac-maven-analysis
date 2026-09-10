#ifndef MAVEN_PORTABLE_ENGINE_H
#define MAVEN_PORTABLE_ENGINE_H
#include "candidate_ranking.h"
#include "engine_tables.h"
typedef struct MavenPortableEngine MavenPortableEngine;
typedef enum {
  MAVEN_ENGINE_OK = 0,
  MAVEN_ENGINE_INVALID = 1,
  MAVEN_ENGINE_ALLOCATION = 2,
  MAVEN_ENGINE_NO_POSITION = 3,
  MAVEN_ENGINE_DIAGNOSTIC = 4,
  MAVEN_ENGINE_UNSUPPORTED = 5,
  MAVEN_ENGINE_CANCELLED = 6,
  MAVEN_ENGINE_EXTERNAL = 7,
  MAVEN_ENGINE_CAPACITY = 8
} MavenEngineResult;
typedef struct {
  void *user;
  void *(*allocate)(void *, size_t);
  void (*release)(void *, void *);
} MavenAllocator;
typedef struct {
  /* Row-major 15x15: zero or lowercase ASCII a..z; blank flags are 0/1.
   * Each rack is zero-terminated, at most seven lowercase letters or '?'. */
  uint8_t letters[225], blanks[225], racks[2][8];
  uint32_t score_bits[2];
  uint16_t row_zero_count;
  uint8_t side;
} MavenPosition;
/* Resources are the recovered Mac Maven resource set, not an arbitrary game
 * configuration. Constructor copies resources and dictionary; callers may
 * release input blobs after return. Allocator must provide normal C alignment.
 * Failure sets *output=NULL and releases every successful allocation. */
MavenEngineResult maven_portable_create(const MavenTableResources *,
                                        MavenBlob dictionary,
                                        const MavenAllocator *,
                                        MavenPortableEngine **output);
void maven_portable_destroy(MavenPortableEngine *);
/* Structural/tile-inventory validation, not Scrabble word legality. Rejects
 * unsupported finished positions (empty rack or zero unseen tiles). Failure
 * leaves the previous position intact. No function is reentrant. */
MavenEngineResult maven_portable_set_position(MavenPortableEngine *,
                                              const MavenPosition *);
MavenEngineResult maven_portable_get_position(const MavenPortableEngine *,
                                              MavenPosition *);
/* Synchronous static heuristic stage only. Every call starts fresh caches;
 * callback observes candidates before insertion, and must not reenter engine.
 * Output and logical position remain unchanged on a diagnostic failure. */
MavenEngineResult maven_portable_heuristic(
    MavenPortableEngine *, int word_deduplication, int16_t leave_offset,
    MavenCandidateList *output,
    void (*candidate)(void *, int phase, int mode, const uint8_t move[34]),
    void *user);
/* Reduced playing level (0-based menu index, 0 == 2100). Runs the heuristic
 * only (never pre-endgame/endgame) with the CODE13 candidate-acceptance filter
 * and a round(cap - player_rating) leave bias, exactly as the original does at
 * a sub-2100 level. The acceptance counter persists across calls (as the
 * original A5-0x1d1e global does); reset it at the start of a new game with
 * maven_portable_level_reset. Level 0 through this entry point is heuristic
 * only with no drop; for true full strength use the normal dispatch instead. */
MavenEngineResult maven_portable_heuristic_leveled(
    MavenPortableEngine *, int level_index, int16_t player_rating,
    MavenCandidateList *output,
    void (*candidate)(void *, int phase, int mode, const uint8_t move[34]),
    void *user);
void maven_portable_level_reset(MavenPortableEngine *);
/* Seed / read the persistent CODE13 acceptance-filter counter (mod 256), for
 * replaying a captured original game from a known counter state. */
void maven_portable_level_set(MavenPortableEngine *, unsigned counter);
unsigned maven_portable_level_counter(const MavenPortableEngine *);
/* Late analyzer for unseen8..16. Explicit force skips original CPU gate;
 * otherwise calibration is a fresh CODE9-style loop count, not host seconds.
 * Gate rejection computes heuristic fallback. Outputs change only on success;
 * used_late receives 1 for late,0 for fallback; estimate is the CPU gate value.
 * Time/cancellation during this synchronous computation are not yet exposed. */
MavenEngineResult maven_portable_late(MavenPortableEngine *, int force,
                                      uint32_t calibration,
                                      MavenCandidateList *output,
                                      int *used_late, uint32_t *estimate);
typedef struct {
  void *user;
  int32_t (*elapsed_seconds)(
      void *); /* Since this search began, rounded as desired. */
  int (*cancel_requested)(void *); /* Optional; between restored iterations. */
  uint32_t private_seed;           /* Nonzero31-bit CODE4 RNG input. */
  int32_t budget_seconds;
} MavenEndgameOptions;
/* Requires all unseen tiles to be exactly the supplied opponent rack (no bag).
 * Owns the original8192-node pool. Fresh hash table comes from private_seed;
 * this isolated search does not consume a game/simulation RNG stream or alter
 * its persistent hash. Clocks remain explicit. CANCELLED leaves caller output
 * and logical position unchanged. This API is not a nonlocal UI exception. */
MavenEngineResult maven_portable_endgame(MavenPortableEngine *,
                                         const MavenEndgameOptions *,
                                         MavenCandidateList *output,
                                         unsigned *iterations);
typedef struct {
  void *user;
  int (*read_ticks)(void *, uint32_t *);
  int (*toolbox_random)(void *, int16_t *);
  uint32_t private_seed, initial_stack_ticks;
} MavenGameRuntime;
typedef struct {
  uint8_t move[34];
  uint32_t features[22], statistics[2][22], evaluation_bits;
  unsigned selected_side;
  int phase;
  size_t history_records;
} MavenGameResult;
/* Commit a candidate from the last successful search of the current position.
 * Owns history/statistics and computes placement, collector, refill and final
 * rack adjustment. No caller-supplied score or forged move is accepted.
 * A successful position change invalidates the last ranking. Runtime callbacks
 * return1 on success,0 on failure; a4096-event limit bounds a stuck clock.
 * Failure preserves logical position/history/statistics, runtime seed and
 * result. External callback consumption cannot be rolled back. On game end,
 * get_position may return side2; further search is unsupported. */
MavenEngineResult maven_portable_play_ranked(MavenPortableEngine *,
                                             unsigned index, MavenGameRuntime *,
                                             MavenGameResult *);
/* Save the owned history in original big-endian record format. Required size
 * is returned through length; insufficient capacity leaves output untouched. */
MavenEngineResult maven_portable_save(MavenPortableEngine *, uint8_t *output,
                                      size_t capacity, size_t *length);
typedef struct {
  MavenGameRuntime random;
  /* Optional per-refill legacy stack input. The ordinary runtime may leave
   * this NULL and use random.initial_stack_ticks for every refill. */
  int (*begin_refill)(void *, uint32_t *initial_stack_ticks);
} MavenHistoryRuntime;
/* Load and replay an original save using owned buffers. Malformed records,
 * impossible inventories, callback failures and allocation failures preserve
 * the prior logical game and runtime seed. History statistics reset, as they
 * are not serialized. Word legality is not validated by file import. */
MavenEngineResult maven_portable_load(MavenPortableEngine *,
                                      const uint8_t *wire, size_t length,
                                      MavenHistoryRuntime *);
/* Restore the position preceding a selected original history record, including
 * its recorded racks and player orientation. Future records are retained; the
 * next play/save appends a snapshot and marker to establish the new branch. */
MavenEngineResult maven_portable_history_select(MavenPortableEngine *,
                                                size_t index,
                                                MavenHistoryRuntime *);
size_t maven_portable_history_count(const MavenPortableEngine *);
typedef struct {
  void *user;
  int lookahead, exhaustive, late_enabled, endgame_enabled;
  uint32_t sample_limit;
  int32_t endgame_budget_seconds;
  uint32_t (*late_calibration)(void *);
  void (*endgame_started)(void *);
  int32_t (*elapsed_seconds)(void *);
  int (*cancel_requested)(void *);
  void (*publish)(void *, const uint8_t *moves, unsigned count);
  void (*event)(void *, int kind, unsigned candidate, unsigned reply);
  /* Optional host failure signal, distinct from an intentional cancellation. */
  int (*runtime_failed)(void *);
} MavenSimulationOptions;
typedef struct {
  uint8_t entries[10][46], published[10][34];
  uint32_t batches, total_weight, publications;
  unsigned count, status; /* status follows MavenSimulationStatus. */
} MavenSimulationResult;
/* Run simulation over the last successful ranking. Uses owned search engines
 * and buffers; all reply modes are configurable. Position/history/statistics
 * are preserved. Random mode requires a positive finite sample limit.
 * Successful completion OR cancellation publishes a result containing the
 * original partial counters and last displayed ranking, and advances runtime
 * RNG state. The last displayed ranking becomes the input for subsequent
 * simulation or play. Simulation hash initialization consumes this same private
 * RNG stream once per engine; callers carry the returned seed between calls.
 * External/diagnostic errors leave result, seed and persistent hash unchanged.
 * Cancellation is cooperative at reply/iteration boundaries. Callbacks must
 * not reenter this engine. Exhaustive mode is restricted to unseen7..17. */
MavenEngineResult maven_portable_simulate(MavenPortableEngine *,
                                          const MavenSimulationOptions *,
                                          MavenHistoryRuntime *,
                                          MavenSimulationResult *);
#endif
