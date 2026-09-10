#ifndef MAVEN_PATTERN_LOOKUP_H
#define MAVEN_PATTERN_LOOKUP_H
#include <stdint.h>
typedef struct {
    const uint8_t *letters;
    uint32_t accumulator;
    int16_t table_index;
} MavenPatternEntry;
/* CODE32 [0x1872,0x18e4): binary search of an already-built sorted cache.
 * Valid count0..16384, unique ASCII strings, nonnegative table indices and
 * in-range28-byte table records required. Returns BE signed word at +26;
 * found zero scores still return a non-NULL accumulator pointer. Cache
 * construction at [0x16c0,0x1872) is in pattern_cache.c. */
int16_t maven_lookup_pattern(MavenPatternEntry *entries, int16_t count, const uint8_t *letters,
                             const uint8_t *score_records, uint32_t **accumulator);
#endif
