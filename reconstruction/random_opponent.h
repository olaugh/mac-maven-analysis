#ifndef MAVEN_RANDOM_OPPONENT_H
#define MAVEN_RANDOM_OPPONENT_H
#include "rack_refill.h"
#include <stdint.h>
/* One iteration of CODE38+12..22. The original infinite loop invokes the
 * simulation callback with this rack and weight1; termination is handled by
 * CODE3 after a complete batch or by the classic exception context.
 * Clears only byte0 of sample and opponent rack, preserving scratch tails.
 * Board row0 is cleared by the original refill. Other rack remains empty.
 * Private RNG/Toolbox/tick effects are supplied through the refill contract.
 * sample needs8bytes; bag needs128bytes. Returns the constructed bag length.
 * The caller supplies original stack ticks for the indeterminate small-bag
 * branch, or chooses and documents a deterministic modern replacement. */
uint32_t maven_draw_random_opponent(uint8_t sample[8], uint8_t other_rack[8],
                                    const uint8_t *own_rack, uint8_t bag[128],
                                    const uint8_t distribution[128], uint8_t board[544],
                                    const uint16_t values[544], const uint8_t *alphabet,
                                    uint32_t initial_stack_ticks, const MavenRefillOps *ops);
#endif
