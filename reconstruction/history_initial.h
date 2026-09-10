#ifndef MAVEN_HISTORY_INITIAL_H
#define MAVEN_HISTORY_INITIAL_H
#include <stdint.h>
typedef struct {
    uint8_t board_bytes[0x220];     /* A5-0x4302 */
    uint8_t auxiliary_bytes[0x440]; /* A5-0x40e2; exact element semantics pending */
    uint8_t racks[2][8];            /* A5-0x3c9a and A5-0x3ca2 */
    uint8_t *selected_rack;         /* A5-0x3c8a */
    uint32_t totals[2];             /* A5-0x3c8e and A5-0x3c92 */
} MavenInitialHistoryState;
/* CODE 7 tag-1 branch [0x70,0xca). Requires a valid payload with both
 * NUL-terminated rack strings fitting eight-byte destinations. */
void maven_restore_initial_history(const uint8_t *payload, MavenInitialHistoryState *state);
#endif
