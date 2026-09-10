#ifndef MAVEN_WORD_BOUNDARY_H
#define MAVEN_WORD_BOUNDARY_H
#include <stdint.h>
/* Decision portion of CODE 9+0x742. Bytes are supplied by the caller;
 * this does not reproduce speculative/out-of-allocation guest reads.
 * allocation_size is GetPtrSize, not the logical text length. */
uint8_t maven_is_word_separator(int16_t index, int32_t allocation_size, uint8_t previous,
                                uint8_t current, uint8_t next, const uint8_t classes[256]);
#endif
