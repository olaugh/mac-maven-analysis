#ifndef MAVEN_SEARCH_DISPATCH_H
#define MAVEN_SEARCH_DISPATCH_H
#include "endgame_search.h"
#include "heuristic_search.h"
#include "late_search.h"
#include "late_search_budget.h"
#include "search_policy.h"
typedef struct {
  MavenHeuristicSearch *heuristic;
  MavenEndgameSearch *endgame;
  MavenLateSearch *late;
  int endgame_enabled, late_enabled;
  int32_t endgame_budget_seconds;
  MavenSearchKind selected_kind;
  uint8_t selected_move[34];
  /* NULL table is the prequalified computational replay path. A standalone
   * compatibility caller supplies the table and a fresh original-style
   * calibration result for every late decision. No host timing assumption. */
  const uint16_t (*late_workload)[9];
  uint32_t (*late_calibration)(void *);
  void *late_calibration_user;
  uint32_t late_estimate;

} MavenSearchDispatch;
/* CODE3[1de,268): count the selected rack, choose an enabled search by unseen
 * total, run it, then copy the first ranked move as the current selection.
 * All supplied engines must share the same application, dictionary, tables
 * and leave state. The caller owns the large late/endgame working buffers.
 * Endgame hash initialization, timing, cancellation and UI remain explicit
 * boundaries. Returns0 if a selected engine is absent/unsupported;1 otherwise.
 * The CODE28 result is the common final candidate list for all three paths.
 * Original complete simulation batches exercise all three selected engines;
 * see analysis/DECOMPILATION-STATUS.md for fixture scope and remaining gaps. */
int maven_select_best_move(MavenSearchDispatch *, uint8_t *own, uint8_t *other);
int maven_select_best_move_shared(MavenSearchDispatch *, uint8_t *own,
                                  uint8_t *other, uint8_t workspace[64]);
#endif
