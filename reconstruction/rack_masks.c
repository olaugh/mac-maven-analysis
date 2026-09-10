#include "rack_masks.h"
#include <string.h>
void maven_build_occurrence_masks(const uint8_t *sorted_rack, uint16_t masks[128][8]) {
    unsigned position, occurrence = 0;
    unsigned length = (unsigned)strlen((const char *)sorted_rack);
    uint16_t all_positions = length < 7 ? 127 : (uint16_t)((1u << length) - 1u);
    for (position = 0; sorted_rack[position]; ++position) {
        uint8_t letter = sorted_rack[position];
        if (!position || sorted_rack[position - 1] != letter)
            occurrence = 0;
        else
            ++occurrence;
        masks[letter][occurrence] = (uint16_t)(all_positions & ~(1u << position));
    }
}
uint16_t maven_canonical_mask_difference(uint16_t parent, uint16_t subset,
                                         const uint8_t *sorted_rack, void (*diagnostic)(void *),
                                         void *user) {
    uint16_t result = (uint16_t)(parent & ~subset), group = 0;
    unsigned position;
    if ((uint16_t)(parent | subset) != parent)
        diagnostic(user);
    for (position = 0; sorted_rack[position]; ++position) {
        uint16_t selection, shifted;
        group |= (uint16_t)(1u << position);
        if (sorted_rack[position] == sorted_rack[position + 1])
            continue;
        selection = (uint16_t)(result & group);
        if (selection) {
            result &= (uint16_t)~group;
            for (;;) {
                if (!selection || selection >= 128)
                    diagnostic(user);
                shifted = (uint16_t)(selection << 1);
                if ((shifted & group) != shifted)
                    break;
                selection = shifted;
            }
            result |= (uint16_t)(shifted >> 1);
        }
        group = 0;
    }
    return result;
}
uint16_t maven_merge_mask_carry(uint16_t mask, uint16_t carry, uint16_t barriers) {
    while (carry) {
        uint16_t previous = mask;
        mask |= carry;
        carry = (uint16_t)((previous & (uint16_t)~barriers & carry) >> 1);
    }
    return (uint16_t)(mask | barriers);
}
int16_t maven_mask_is_listed(const int16_t *descending, int16_t count, int16_t mask) {
    int low = 0, high = count - 1;
    while (low <= high) {
        int middle = (low + high) / 2;
        int16_t value = descending[middle];
        if (value == mask)
            return 1;
        if (value > mask)
            low = middle + 1;
        else
            high = middle - 1;
    }
    return 0;
}
uint8_t *maven_rack_from_mask(uint8_t *output, const uint8_t *source, const uint32_t *bits,
                              int16_t mask, const int16_t *descending, int16_t count,
                              void (*diagnostic)(void *), void *user) {
    uint8_t *next = output;
    uint32_t extended = (uint32_t)(int32_t)mask;
    if (!maven_mask_is_listed(descending, count, mask))
        diagnostic(user);
    while (*source) {
        if (extended & *bits)
            *next++ = *source;
        ++source;
        ++bits;
    }
    *next = 0;
    return output;
}

unsigned maven_prepare_canonical_rack_masks(const uint8_t *rack, const uint16_t values[128],
                                            uint16_t masks[128], uint16_t points[128],
                                            uint16_t occurrences[128][8]) {
    unsigned count = 0;
    int mask;
    memset(masks, 0, 128 * sizeof(uint16_t));
    memset(points, 0, 128 * sizeof(uint16_t));
    maven_build_occurrence_masks(rack, occurrences);
    for (mask = 127; mask >= 0; --mask) {
        unsigned position;
        uint16_t sum = 0;
        for (position = 0; rack[position]; ++position)
            if (mask & (1u << position)) {
                if (rack[position] == rack[position + 1] && !(mask & (1u << (position + 1))))
                    break;
                sum = (uint16_t)(sum + values[rack[position]]);
            }
        if (rack[position])
            continue;
        masks[count++] = (uint16_t)mask;
        points[mask] = sum;
    }
    return count;
}

int16_t maven_find_rack_mask(const uint8_t *rack, const uint8_t *residual, const int16_t *masks,
                             int16_t count, void (*diagnostic)(void *), void *user) {
    int i;
    for (i = 0; i < count; ++i) {
        uint8_t letters[8];
        unsigned j, n = 0;
        for (j = 0; rack[j]; ++j)
            if ((uint16_t)masks[i] & (1u << j))
                letters[n++] = rack[j];
        letters[n] = 0;
        if (!strcmp((const char *)letters, (const char *)residual))
            return masks[i];
    }
    if (diagnostic)
        diagnostic(user);
    return -1;
}
