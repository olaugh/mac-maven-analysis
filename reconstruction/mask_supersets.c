#include "mask_supersets.h"
void maven_add_to_mask_supersets(uint16_t values[128], uint32_t stamps[128], uint32_t generation,
                                 const uint16_t masks[7], uint16_t initial, int16_t delta) {
    unsigned i;
    if (stamps[initial] == generation)
        return;
    stamps[initial] = generation;
    values[initial] = (uint16_t)(values[initial] + (uint16_t)delta);
    for (i = 0; i < 7; ++i)
        maven_add_to_mask_supersets(values, stamps, generation, masks,
                                    (uint16_t)(initial | masks[i]), delta);
}
