#include "pattern_lookup.h"
#include <stddef.h>
static int compare(const uint8_t *a, const uint8_t *b) {
    while (*a && *a == *b) {
        ++a;
        ++b;
    }
    return (int)*a - (int)*b;
}
int16_t maven_lookup_pattern(MavenPatternEntry *entries, int16_t count, const uint8_t *letters,
                             const uint8_t *records, uint32_t **accumulator) {
    int low = 0, high = count - 1;
    *accumulator = NULL;
    while (low <= high) {
        int middle = (low + high) / 2, order = compare(letters, entries[middle].letters);
        if (!order) {
            const uint8_t *value = records + 28 * entries[middle].table_index + 26;
            uint16_t bits = (uint16_t)((uint16_t)value[0] << 8 | value[1]);
            *accumulator = &entries[middle].accumulator;
            return bits < 32768 ? (int16_t)bits : (int16_t)((int32_t)bits - 65536);
        }
        if (order < 0)
            high = middle - 1;
        else
            low = middle + 1;
    }
    return 0;
}
