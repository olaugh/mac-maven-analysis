#ifndef MAVEN_MOVE_STATISTICS_H
#define MAVEN_MOVE_STATISTICS_H
#include <stdint.h>
/* CODE16 [4,0x2c): add22 longs, forward order, modulo2^32. */
void maven_add_move_statistics(const uint32_t source[22], uint32_t destination[22]);
/* CODE16 [0x2c,0x14c): copy then normalize selected score fields by
 * scale_count*100 with half-divisor addition. Field14 uses field0 instead.
 * Inputs are raw 32-bit words with signed division; both resulting divisors
 * must be nonzero. Exact caller meaning of scale_count remains to be traced.
 * This does not implement a weighted move-ranking formula. */
void maven_normalize_move_statistics(uint32_t destination[22], const uint32_t source[22],
                                     uint32_t scale_count);
#endif
