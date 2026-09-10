#ifndef MAVEN_RACK_MASKS_H
#define MAVEN_RACK_MASKS_H
#include <stdint.h>
/* CODE32[0x824,0x8bc) for a sorted pool of <=16 ASCII tiles,
 * with at most8 copies of each tile. Only the
 * slots corresponding to present tile occurrences are written; others retain
 * prior contents. Each entry clears that physical rack position from max(127,(1<<pool_length)-1).
 * The original emits the sorted rack from counts before this loop. */
void maven_build_occurrence_masks(const uint8_t *sorted_rack, uint16_t masks[128][8]);
/* CODE32[0x1242,0x12ce): subtract subset from parent, then shift selections
 * within each equal-letter group toward that group's high bits. Valid original
 * seven-bit masks and sorted rack required; subset must be contained in parent.
 * Diagnostic may return. This selects canonical duplicate tile occurrences. */
uint16_t maven_canonical_mask_difference(uint16_t parent, uint16_t subset,
                                         const uint8_t *sorted_rack, void (*diagnostic)(void *),
                                         void *user);
/* CODE32[0x12ce,0x1304): merge mask/carry, propagating overlapping bits downward
 * except across barrier bits, then include barriers. Valid seven-bit inputs. */
uint16_t maven_merge_mask_carry(uint16_t mask, uint16_t carry, uint16_t barriers);
/* CODE32 [0x7da,0x824): signed-word search of a DESCENDING mask list.
 * Valid count0..16384 avoids original midpoint word overflow. */
int16_t maven_mask_is_listed(const int16_t *descending, int16_t count, int16_t mask);
/* CODE32 [0x650,0x6a2), with validation at[0x7c0,0x7da).
 * Emits source letters whose corresponding32-bit mask intersects the
 * sign-extended input mask. Output capacity at least strlen(source)+1.
 * Validation diagnostics may return; original still builds the string. */
uint8_t *maven_rack_from_mask(uint8_t *output, const uint8_t *source, const uint32_t *bits,
                              int16_t mask, const int16_t *descending, int16_t count,
                              void (*diagnostic)(void *), void *user);
/* CODE32[0x115c,0x11e6): clear and prepare descending canonical mask list
 * and wrapped tile-point sums, including unused high-bit variants. */
unsigned maven_prepare_canonical_rack_masks(const uint8_t *sorted_rack,
                                            const uint16_t letter_values[128], uint16_t masks[128],
                                            uint16_t points[128],
                                            uint16_t occurrence_masks[128][8]);
/* CODE32[0x11e6,0x1242): first descending canonical mask whose selected
 * letters equal the requested residual rack. Returns-1 after diagnostic if
 * no canonical mask matches (the original diagnostic path is undefined). */
int16_t maven_find_rack_mask(const uint8_t *rack, const uint8_t *residual,
                             const int16_t *canonical_masks, int16_t count,
                             void (*diagnostic)(void *), void *user);
#endif
