#ifndef MAVEN_HISTORY_SNAPSHOT_H
#define MAVEN_HISTORY_SNAPSHOT_H
#include <stddef.h>
#include <stdint.h>
/* CODE7 tag0 [00ca,0240): restore a300-byte board/rack/score snapshot.
 * Values use host-endian point*100 words. Transposed border columns retain
 * their prior bytes, as in the original. Caller owns all supplied arrays.
 * The checked port rejects truncated records, non-ASCII cells, unterminated
 * racks and out-of-board blank coordinates before modifying any output.
 * Returns1 on success,0 on malformed input. selected_side becomes0. */
int maven_restore_history_snapshot(const uint8_t *payload,size_t length,
    uint8_t board[544],uint16_t values[544],uint8_t racks[2][8],
    uint32_t totals[2],int *selected_side,const uint16_t letter_values[128]);
#endif
