#ifndef MAVEN_RACK_REFILL_H
#define MAVEN_RACK_REFILL_H
#include <stdint.h>
typedef struct {
    void *user;
    uint32_t (*private_random)(void *);
    int16_t (*toolbox_random)(void *);
    uint32_t (*read_ticks)(void *);
} MavenRefillOps;
/* CODE4 [4,0x30), with caller-owned representation of A5-0xdc4. */
uint32_t maven_private_random_next(uint32_t *state);
/* CODE31 [0x7f4,0x8b4), after bag construction at +0x8be.
 * Valid rack capacity >=8, rack length <=7, bag storage >=bag_length.
 * The original skips tick initialization when bag_length<=8-rack_length.
 * initial_stack_ticks explicitly supplies that indeterminate entry value;
 * it is ignored if the tick-initializing branch executes. Callbacks preserve
 * external effects and order. read_ticks must eventually change to terminate.
 * Mutates bag by swaps; clears the first 17 board bytes after drawing. */
void maven_refill_rack_from_bag(uint8_t *rack, uint8_t *bag, uint32_t bag_length,
                                uint8_t board[544], uint32_t initial_stack_ticks,
                                const MavenRefillOps *ops);
#endif
