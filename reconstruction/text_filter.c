#include "text_filter.h"

int16_t maven_filter_ascii(const uint8_t *source, uint8_t *destination, const uint8_t *allowed) {
    uint16_t accepted[256] = {0};
    int16_t changed = 0;
    while (*allowed)
        accepted[*allowed++] = 1;
    /* Preserve the original copy-before-test ordering and final terminator. */
    while ((*destination = *source) != 0) {
        if (accepted[*destination])
            ++destination;
        else
            changed = 1;
        ++source;
    }
    return changed;
}
