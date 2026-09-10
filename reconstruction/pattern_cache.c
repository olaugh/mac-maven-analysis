#include "pattern_cache.h"
#include <string.h>
static int16_t word(const uint8_t *p) {
    unsigned n = ((unsigned)p[0] << 8) | p[1];
    return n < 32768 ? (int16_t)n : (int16_t)((int)n - 65536);
}
void maven_prepare_pattern_cache(MavenPatternCache *cache, const uint8_t *records,
                                 int16_t record_count, const uint8_t *strings,
                                 void *(*allocate)(void *, size_t), void (*diagnostic)(void *),
                                 void *user) {
    int i, allocated, gap;
    if (cache->entries)
        return;
    if (cache->count)
        diagnostic(user);
    for (i = 1; i < record_count; ++i)
        if (word(records + 8 * i + 4) && !records[8 * i + 6])
            ++cache->count;
    allocated = cache->count;
    cache->entries = allocate(user, (size_t)allocated * sizeof *cache->entries);
    cache->count = 0;
    for (i = 1; i < record_count; ++i) {
        const uint8_t *r = records + 8 * i;
        if (word(r + 4) && !r[6]) {
            const uint8_t *letters = strings + word(r + 2), *p = letters;
            MavenPatternEntry *e = &cache->entries[cache->count++];
            e->letters = letters;
            while (*++p)
                if (*p < p[-1])
                    diagnostic(user);
            e->accumulator = 0;
            e->table_index = word(r + 4);
        }
    }
    if (cache->count != allocated)
        diagnostic(user);
    gap = 0;
    do {
        gap = 3 * gap + 1;
    } while (gap < cache->count);
    do {
        gap /= 3;
        for (i = gap; i < cache->count; ++i) {
            MavenPatternEntry saved = cache->entries[i];
            int j = i;
            while (j >= gap && strcmp((const char *)saved.letters,
                                      (const char *)cache->entries[j - gap].letters) < 0) {
                cache->entries[j] = cache->entries[j - gap];
                j -= gap;
            }
            cache->entries[j] = saved;
        }
    } while (gap > 1);
    for (i = 1; i < cache->count; ++i)
        if (strcmp((const char *)cache->entries[i].letters,
                   (const char *)cache->entries[i - 1].letters) <= 0)
            diagnostic(user);
}
