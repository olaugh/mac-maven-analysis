#ifndef MAVEN_SMART_QUOTES_H
#define MAVEN_SMART_QUOTES_H
#include <stdint.h>
/* Decision portion of CODE 9+0x880..0x91e. previous is the byte preceding
 * selection_start; at start zero its value does not affect the result.
 * The original's premature read before an empty text buffer is not emulated. */
uint8_t maven_smart_quote(uint8_t character, int16_t selection_start, uint8_t previous,
                          const uint8_t classes[256]);
#endif
