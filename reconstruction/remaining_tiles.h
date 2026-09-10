#ifndef MAVEN_REMAINING_TILES_H
#define MAVEN_REMAINING_TILES_H
#include <stdint.h>
/* CODE31 [0x8be,0x992): rebuild the bag from distribution, board and racks.
 * Valid ASCII characters and enough output capacity required. Value zero
 * marks a blank on rows 1..15; row zero always consumes its literal letter.
 * Counts wrap as bytes and negative signed counts emit no tiles. */
uint32_t maven_collect_remaining_tiles(uint8_t *output, const uint8_t distribution[128],
                                       const uint8_t board[544], const uint16_t values[544],
                                       const uint8_t *rack0, const uint8_t *rack1,
                                       const uint8_t *alphabet);
/* CODE31 [0x75c,0x7e0): counts unseen from one rack's perspective.
 * Scans linear board cells[17,272), subtracts selected-rack counts, clamps
 * negative signed-byte alphabet counts to zero and returns wrapped word sum. */
int16_t maven_count_unseen_tiles(uint8_t output[128], const uint8_t distribution[128],
                                 const uint8_t board[544], const uint16_t values[544],
                                 const uint8_t rack_counts[128], const uint8_t *alphabet);
#endif
