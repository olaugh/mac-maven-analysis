#ifndef MAVEN_CROSS_WORD_POSSIBLE_H
#define MAVEN_CROSS_WORD_POSSIBLE_H
#include <stdint.h>
/* CODE32 [0x6a2,0x7c0): try available letters at an empty square with an
 * existing perpendicular neighbor. Only the paired-orientation cell is
 * temporarily written; it is cleared on success and failure. Valid ASCII,
 * paired32x17 board with zero sentinels and valid1..30/1..15 coordinates.
 * available counts are tested for nonzero, not positivity. Callback must
 * consume the C string synchronously and not retain its transient pointer. */
int16_t maven_cross_word_possible(const int16_t available[128], const uint8_t *alphabet,
                                  int16_t row, int16_t column, uint8_t board[544],
                                  int32_t (*contains)(void *, const uint8_t *),
                                  void (*diagnostic)(void *), void *user);
#endif
