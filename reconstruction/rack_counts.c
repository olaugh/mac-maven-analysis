#include "rack_counts.h"
/* CODE 31 [0x992,0x9d2). Counts wrap at eight bits. */
void maven_count_rack(uint8_t counts[128], const uint8_t *alphabet, const uint8_t *rack) {
    const uint8_t *p;
    for (p = alphabet; *p; ++p)
        counts[*p] = 0;
    for (p = rack; *p; ++p)
        ++counts[*p];
}
/* CODE 31 [0x71e,0x75c). Signed EXT.W of each count controls the loop. */
void maven_rack_from_counts(uint8_t *rack, const uint8_t counts[128], const uint8_t *alphabet) {
    for (; *alphabet; ++alphabet) {
        unsigned count = counts[*alphabet];
        if (count >= 128)
            continue;
        while (count--)
            *rack++ = *alphabet;
    }
    *rack = 0;
}
