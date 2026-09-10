#include "simulation_restore.h"
#include <string.h>
void maven_save_simulation_position(MavenSimulationSnapshot *s, const uint8_t board[544],
                                    const uint16_t values[544], const uint8_t *rack0,
                                    const uint8_t *rack1, int selected_side) {
    memcpy(s->board, board, sizeof s->board);
    memcpy(s->values, values, sizeof s->values);
    strcpy((char *)s->racks[0], (const char *)rack0);
    strcpy((char *)s->racks[1], (const char *)rack1);
    s->selected_side = selected_side;
}
void maven_restore_simulation_position(const MavenSimulationSnapshot *s, uint8_t board[544],
                                       uint16_t values[544], uint8_t *rack0, uint8_t *rack1,
                                       int *selected_side) {
    memcpy(board, s->board, sizeof s->board);
    memcpy(values, s->values, sizeof s->values);
    strcpy((char *)rack0, (const char *)s->racks[0]);
    strcpy((char *)rack1, (const char *)s->racks[1]);
    *selected_side = s->selected_side;
}
int maven_simulation_sample_limit_reached(const uint8_t *e, uint32_t limit, int exhaustive) {
    uint32_t count = (uint32_t)e[42] << 24 | (uint32_t)e[43] << 16 | (uint32_t)e[44] << 8 | e[45];
    /* Flipping sign bits gives a defined unsigned ordering of signed32 words. */
    return !exhaustive && (count ^ UINT32_C(0x80000000)) >= (limit ^ UINT32_C(0x80000000));
}
