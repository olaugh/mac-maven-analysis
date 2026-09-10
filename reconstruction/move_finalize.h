#ifndef MAVEN_MOVE_FINALIZE_H
#define MAVEN_MOVE_FINALIZE_H
#include <stdint.h>
/* CODE31 [0x456,0x4f6): two recorded coordinates and their paired cells.
 * Coordinates must address the 544-word allocation in both orientations. */
void maven_clear_recorded_move_values(uint16_t values[544], int16_t first_row, int16_t first_column,
                                      int16_t second_row, int16_t second_column);
/* CODE31 [0x4f6,0x52a): append marker and old rack, then rebuild rack.
 * Valid NUL-terminated ASCII rack, alphabet and destination capacity required.
 * Diagnostic may return, as in Maven; it is not a bounds-checking API. */
void maven_finish_move_rack(uint8_t undo[33], int16_t undo_end, uint8_t *rack,
                            const uint8_t counts[128], const uint8_t *alphabet,
                            void (*diagnostic)(void *), void *user);
#endif
