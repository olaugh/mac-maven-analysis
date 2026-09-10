#ifndef MAVEN_CHARACTER_NORMALIZATION_H
#define MAVEN_CHARACTER_NORMALIZATION_H
#include <stdint.h>

/* CODE 52+0x15e: low-byte classification, with a full 16-bit return value.
 * Pass the application's 256-byte character table (A5-0x428).
 */
int16_t maven_lowercase_character(int16_t character, const uint8_t classes[256]);

/* CODE 23+0x1be: destination must fit source including its NUL terminator.
 * Exact in-place conversion is supported. Returns the original destination.
 */
uint8_t *maven_copy_lowercase(uint8_t *destination, const uint8_t *source,
                              const uint8_t classes[256]);
#endif
