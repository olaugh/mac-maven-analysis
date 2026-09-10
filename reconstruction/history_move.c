#include "history_move.h"
#include <string.h>
/* CODE 7 [0x278,0x2e6). Global state can change during recursive restore;
 * the original reads selector, score and rack strings only after it returns. */
void maven_restore_move_history(const uint8_t *payload, int16_t history_index,
                                MavenInitialHistoryState *state, const MavenMoveHistoryOps *ops) {
    uint16_t prior = (uint16_t)((uint16_t)history_index - 1);
    unsigned player;
    uint32_t score;
    uint8_t *rack;
    ops->restore_previous(ops->user,
                          prior < 32768 ? (int16_t)prior : (int16_t)((int32_t)prior - 65536));
    player = (payload[0x22] || payload[0x23]) ? 0 : 1;
    rack = state->racks[player];
    strcpy((char *)state->racks[1 - player], (const char *)payload + 0x2c);
    score = (uint32_t)payload[0x10] << 24 | (uint32_t)payload[0x11] << 16 |
            (uint32_t)payload[0x12] << 8 | payload[0x13];
    state->totals[player] += score;
    strcpy((char *)rack, (const char *)payload + 0x24);
    ops->count_rack(ops->user, rack);
    ops->apply_move(ops->user, payload, rack, 0);
    ops->refresh_rack(ops->user, rack);
}
