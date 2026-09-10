#ifndef MAVEN_DECIMAL_SCAN_H
#define MAVEN_DECIMAL_SCAN_H
#include <stdint.h>
/* Specialization of CODE 24 scanner for the observed single "%d" format.
 * No stream effects, other formats, or host errno. The supplied errno word
 * is preserved except on overflow, when the original writes 34.
 */
int16_t maven_scan_decimal_word(const uint8_t *text, int16_t *destination, int16_t *error_number,
                                const uint8_t character_classes[256]);
#endif
