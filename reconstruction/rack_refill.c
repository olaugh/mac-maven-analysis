#include "rack_refill.h"
#include <string.h>
uint32_t maven_private_random_next(uint32_t *state) {
    uint32_t old = *state;
    *state = (old >> 1) + ((((old >> 4) ^ old) & 1) ? UINT32_C(0x40000000) : 0);
    return *state;
}
void maven_refill_rack_from_bag(uint8_t *rack, uint8_t *bag, uint32_t bag_length,
                                uint8_t board[544], uint32_t initial_stack_ticks,
                                const MavenRefillOps *ops) {
    uint32_t length = (uint32_t)strlen((const char *)rack);
    uint32_t ticks = initial_stack_ticks;
    if (bag_length > 8 - length) {
        uint32_t current;
        ticks = ops->read_ticks(ops->user);
        current = ticks;
        while (current == ticks) {
            uint32_t random = ops->private_random(ops->user);
            uint32_t index;
            uint8_t letter;
            random += (uint32_t)(int32_t)ops->toolbox_random(ops->user);
            index = random % bag_length;
            letter = bag[index];
            bag[index] = bag[bag_length - 1];
            bag[bag_length - 1] = letter;
            current = ops->read_ticks(ops->user);
        }
    }
    while (length < 7 && bag_length) {
        uint32_t random = ops->private_random(ops->user);
        uint32_t index;
        random += (uint32_t)(int32_t)ops->toolbox_random(ops->user);
        random += ticks;
        index = random % bag_length;
        rack[length++] = bag[index];
        --bag_length;
        bag[index] = bag[bag_length];
        ticks += 211;
    }
    rack[length] = 0;
    memset(board, 0, 17);
}
