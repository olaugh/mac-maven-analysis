#ifndef MAVEN_PATTERN_MATCH_H
#define MAVEN_PATTERN_MATCH_H
#include <stddef.h>
#include <stdint.h>
typedef struct {
    const uint8_t *records, *strings, *score_records, *board;
    const uint16_t *values, *letter_values;
    uint8_t *rack_counts;
    int16_t record_count;
    void (*diagnostic)(void *);
    void *user;
} MavenPatternMatchInput;
typedef struct {
    uint32_t total_bits;
    size_t count;
} MavenPatternMatchResult;
/* CODE35 [0xa48,0xcd0): match rack multisets and anchored board patterns.
 * Original BE8-byte records and BE28-byte score records; signed offsets.
 * Linked records must terminate at0, remain in bounds, and refer to valid
 * board coordinates. Valid ASCII strings and native decoded word arrays.
 * Optional output arrays must hold record_count entries incl terminator.
 * Counts are temporarily decremented but restored before return. */
MavenPatternMatchResult maven_match_patterns(const MavenPatternMatchInput *in, int16_t board_only,
                                             int16_t *record_ids, int16_t *weights);
#endif
