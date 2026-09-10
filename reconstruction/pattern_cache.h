#ifndef MAVEN_PATTERN_CACHE_H
#define MAVEN_PATTERN_CACHE_H
#include "pattern_lookup.h"
#include <stddef.h>
typedef struct {
    MavenPatternEntry *entries;
    int16_t count;
} MavenPatternCache;
/* CODE32 [0x16c0,0x1872), valid records and nonempty ASCII string storage.
 * records are original 8-byte big-endian records, string offsets signed16.
 * Cache owns allocator-provided storage; strings remain borrowed. Initial
 * state must be {NULL,0}; at most9841 eligible records (safe gap arithmetic).
 * Allocation must succeed, including a usable non-NULL allocation for zero
 * entries if repeat-initialization suppression is desired. Diagnostics may
 * return, as in the original. Native entry size replaces original10 bytes. */
void maven_prepare_pattern_cache(MavenPatternCache *cache, const uint8_t *records,
                                 int16_t record_count, const uint8_t *strings,
                                 void *(*allocate)(void *, size_t), void (*diagnostic)(void *),
                                 void *user);
#endif
