#ifndef MAVEN_RACK_COUNTS_H
#define MAVEN_RACK_COUNTS_H
#include <stdint.h>
/* ASCII contract: the original sign-extends byte indices, so high-bit text
 * can address before the table. Only alphabet entries are cleared. */
void maven_count_rack(uint8_t counts[128], const uint8_t *alphabet, const uint8_t *rack);
/* Caller supplies capacity for all positive signed-byte counts plus NUL.
 * Output follows alphabet order; counts with bit 7 set emit no characters. */
void maven_rack_from_counts(uint8_t *rack, const uint8_t counts[128], const uint8_t *alphabet);
#endif
