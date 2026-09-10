#ifndef MAVEN_SIMULATION_RESTORE_H
#define MAVEN_SIMULATION_RESTORE_H
#include <stdint.h>
typedef struct {
    uint8_t board[544], racks[2][8];
    uint16_t values[544];
    int selected_side;
} MavenSimulationSnapshot;
/* CODE3+c8a..cca and+d86..dbe. Snapshot/restore the session's board, values,
 * rack strings and current-player selector around simulation or cancellation.
 * Rack copying stops after NUL, as CODE52+21c does; scratch tails are not reset.
 * Counts, undo/scorer scratch, caches and candidate totals are not rolled back.
 * The caller subsequently recounts the selected rack and prepares its leave
 * table (CODE3+dd6..de2). Native setjmp or an explicit cancellation result must
 * route here while the snapshot is still alive; no guest jmp_buf is portable.
 */
void maven_save_simulation_position(MavenSimulationSnapshot *, const uint8_t board[544],
                                    const uint16_t values[544], const uint8_t *rack0,
                                    const uint8_t *rack1, int selected_side);
void maven_restore_simulation_position(const MavenSimulationSnapshot *, uint8_t board[544],
                                       uint16_t values[544], uint8_t *rack0, uint8_t *rack1,
                                       int *selected_side);
/* CODE3+65a..670: exhaustive mode returns normally; random sampling unwinds
 * when the FIRST candidate's accumulated signed32 weight reaches the signed32
 * configured limit. This check is after all candidates and rack restoration.
 * Requires at least one original46-byte candidate record. */
int maven_simulation_sample_limit_reached(const uint8_t *entries, uint32_t limit_bits,
                                          int exhaustive);
#endif
