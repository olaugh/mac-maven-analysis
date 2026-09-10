#ifndef MAVEN_TEXT_FILTER_H
#define MAVEN_TEXT_FILTER_H
#include <stdint.h>
/* CODE 9+0xca2: ASCII input/allow-list contract. Exact in-place filtering is
 * supported. Returns 1 if any byte was removed, otherwise 0. The original
 * sign-extends bytes used as table indices; high-bit input is not covered. */
int16_t maven_filter_ascii(const uint8_t *source, uint8_t *destination, const uint8_t *allowed);
#endif
