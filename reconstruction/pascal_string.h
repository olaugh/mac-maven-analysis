#ifndef MAVEN_PASCAL_STRING_H
#define MAVEN_PASCAL_STRING_H
#include <stdint.h>
/* Buffer contains a length byte followed by that many bytes. Conversion
 * preserves embedded NUL bytes and returns the original buffer pointer. */
uint8_t *maven_pascal_to_c(uint8_t *buffer);
/* CODE 23+0xbc specialization for the observed "%s" format. Source length
 * must be <=255; nonoverlapping destination requires length+2 bytes because
 * the original sprintf leaves a NUL after the Pascal payload. No truncation.
 * This contract does not make the original dialog's 256-byte buffer safe
 * for a 255-character input. */
uint8_t *maven_c_to_pascal(uint8_t *destination, const uint8_t *source);
/* CODE 23 [0x17a,0x1be). Historical comparison, not general string equality:
 * compares lengths, then indices 1 through signed(length)-1. */
int16_t maven_pascal_mismatch(const uint8_t *left, const uint8_t *right);
#endif
