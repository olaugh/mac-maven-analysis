#ifndef MAVEN_POOL_WEIGHTS_H
#define MAVEN_POOL_WEIGHTS_H
#include <stdint.h>
/* CODE42's seven-tile rack multiplicities. Physical masks refer to positions
 * in the sorted unseen pool, which may contain7..16 tiles. Each tile's
 * occurrence mask clears one physical position; duplicate requirements must
 * use the original canonical low-position prefix. No probability normalization
 * occurs here: callers divide these integer weights by C(pool size,7).
 * Valid original pools have at most8 copies of each tile and <=2 blanks. */
typedef struct {
    uint16_t unique_mask, total;
    uint8_t multiple_letters[28];
} MavenPoolWeights;
/* CODE42+4. distinct and multiple_letters are emitted in alphabet order.
 * Only cache[0..total) is overwritten. Its original storage begins at
 * occurrence row123 (pseudo-letter {); both explicit arrays receive those
 * overlapping writes. This sentinel is required by the recursive counter. */
void maven_prepare_pool_weights(MavenPoolWeights *, const uint8_t counts[128],
                                const uint8_t *alphabet, uint16_t occurrences[128][8],
                                uint8_t distinct[28], uint16_t cache[48]);
/* CODE42+a8/166: weighted number of seven-tile racks containing requirements.
 * counts['{'] is a temporary aggregate bucket and is cleared before return
 * on the recursive path. Other counts remain unchanged. choose is the
 * original eight-column binomial table. Results wrap to16 bits. */
uint16_t maven_count_pool_racks(const MavenPoolWeights *, uint8_t counts[128],
                                uint16_t requirements, const uint16_t occurrences[128][8],
                                const uint16_t choose[][8]);
#endif
