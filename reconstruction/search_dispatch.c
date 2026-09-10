#include "search_dispatch.h"
#include "rack_counts.h"
#include "remaining_tiles.h"
#include <string.h>
int maven_select_best_move_shared(MavenSearchDispatch *s, uint8_t *own,
                                  uint8_t *other, uint8_t workspace[64]) {
  MavenHeuristicSearch *h = s->heuristic;
  MavenApplyState *app = h->evaluation->application;
  MavenLeaveTable *leaves = h->leaves;
  uint8_t unseen[128] = {0};
  int16_t total;
  maven_count_rack(app->placement.counts, app->alphabet, own);
  total = maven_count_unseen_tiles(unseen, h->evaluation->distribution,
                                   app->placement.board, app->placement.values,
                                   app->placement.counts, app->alphabet);
  s->selected_kind =
      maven_choose_search_kind(total, s->endgame_enabled, s->late_enabled);
  if (s->selected_kind == MAVEN_SEARCH_LATE && s->late_workload) {
    int decision;
    if (!s->late_calibration)
      return 0;
    decision = maven_late_search_decision(
        s->late_workload, app->placement.counts['?'], unseen['?'],
        (unsigned)total, s->late_calibration(s->late_calibration_user), 0,
        &s->late_estimate);
    if (decision < 0)
      return 0;
    if (decision)
      s->selected_kind = MAVEN_SEARCH_HEURISTIC;
  }
  h->evaluation->rack = own;
  h->opponent_rack = other;
  if (s->selected_kind == MAVEN_SEARCH_ENDGAME) {
    MavenEndgameSearch *end = s->endgame;
    MavenEndgameGeneration *g;
    if (!end)
      return 0;
    g = end->leaf.generation;
    if (g->application != app)
      return 0;
    end->own_rack = own;
    end->other_rack = other;
    end->budget_seconds = s->endgame_budget_seconds;
    memcpy(end->selected_move, s->selected_move, 34);
    memcpy(end->leave_values, leaves->values, sizeof end->leave_values);
    g->ranking = *h->result;
    maven_search_endgame_shared(end, workspace);
    *h->result = g->ranking;
    memcpy(leaves->values, end->leave_values, sizeof leaves->values);
    memcpy(leaves->canonical_masks, g->canonical_masks,
           sizeof leaves->canonical_masks);
    memcpy(leaves->tile_points, g->tile_points, sizeof leaves->tile_points);
    memcpy(leaves->occurrence_masks, g->occurrence_masks,
           sizeof leaves->occurrence_masks);
    leaves->mask_count = (int16_t)g->mask_count;
    leaves->sorted_rack = g->sorted_rack;
  } else if (s->selected_kind == MAVEN_SEARCH_LATE) {
    MavenLateSearch *late = s->late;
    if (!late || late->application != app || late->leaves != leaves)
      return 0;
    late->own_rack = own;
    late->force = 0; /* CODE3+236 supplies a zero word. */
    if (!maven_search_late_game_shared(late, workspace))
      return 0;
    *h->result = late->ranking;
  } else {
    maven_search_heuristic_moves_shared(h, workspace);
  }
  memcpy(s->selected_move, h->result->moves[0], 34);
  return 1;
}

int maven_select_best_move(MavenSearchDispatch *s, uint8_t *own,
                           uint8_t *other) {
  return maven_select_best_move_shared(s, own, other, NULL);
}
