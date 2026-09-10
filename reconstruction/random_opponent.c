#include "random_opponent.h"
#include "remaining_tiles.h"
uint32_t maven_draw_random_opponent(uint8_t sample[8], uint8_t other_rack[8],
                                    const uint8_t *own_rack, uint8_t bag[128],
                                    const uint8_t distribution[128], uint8_t board[544],
                                    const uint16_t values[544], const uint8_t *alphabet,
                                    uint32_t initial_stack_ticks, const MavenRefillOps *ops) {
    uint32_t length;
    sample[0] = 0;
    other_rack[0] = 0;
    length = maven_collect_remaining_tiles(bag, distribution, board, values, own_rack, other_rack,
                                           alphabet);
    maven_refill_rack_from_bag(sample, bag, length, board, initial_stack_ticks, ops);
    return length;
}
