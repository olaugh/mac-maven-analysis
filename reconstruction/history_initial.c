#include "history_initial.h"
#include <string.h>
void maven_restore_initial_history(const uint8_t *payload, MavenInitialHistoryState *state) {
    memset(state->board_bytes, 0, sizeof state->board_bytes);
    memset(state->auxiliary_bytes, 0, sizeof state->auxiliary_bytes);
    strcpy((char *)state->racks[0], (const char *)payload + 6);
    strcpy((char *)state->racks[1], (const char *)payload + 14);
    state->selected_rack = state->racks[(payload[2] || payload[3]) ? 0 : 1];
    state->totals[0] = 0;
    state->totals[1] = 0;
}
