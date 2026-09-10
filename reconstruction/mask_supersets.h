#ifndef MAVEN_MASK_SUPERSETS_H
#define MAVEN_MASK_SUPERSETS_H
#include <stdint.h>
/* CODE32 [0x18e4,0x1944): recursively OR seven masks, adding delta once per
 * reachable mask for this generation. Valid masks0..127 required. Stamps
 * equal to generation suppress the entire visit, including the initial mask. */
void maven_add_to_mask_supersets(uint16_t values[128], uint32_t stamps[128], uint32_t generation,
                                 const uint16_t masks[7], uint16_t initial, int16_t delta);
#endif
