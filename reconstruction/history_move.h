#ifndef MAVEN_HISTORY_MOVE_H
#define MAVEN_HISTORY_MOVE_H
#include "history_initial.h"
typedef struct {
    void *user;
    void (*restore_previous)(void *, int16_t history_index);
    void (*count_rack)(void *, uint8_t *rack);
    void (*apply_move)(void *, const uint8_t *payload, uint8_t *rack, int16_t evaluate);
    void (*refresh_rack)(void *, uint8_t *rack);
} MavenMoveHistoryOps;
/* Tag 2 branch only: prior history restoration and move application are
 * explicit dependencies, not yet a complete standalone game replay. */
void maven_restore_move_history(const uint8_t *payload, int16_t history_index,
                                MavenInitialHistoryState *state, const MavenMoveHistoryOps *ops);
#endif
