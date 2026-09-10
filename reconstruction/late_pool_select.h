#ifndef MAVEN_LATE_POOL_SELECT_H
#define MAVEN_LATE_POOL_SELECT_H
#include <stdint.h>
/* CODE36's compact reply records are not a host ABI struct: fields overlap
 * the embedded34-byte move during later stages. Named offsets below describe
 * the original66-byte layout; all multi-byte accesses are explicitly big-endian. */
enum {
    MAVEN_LATE_NEXT = 0,
    MAVEN_LATE_SCORE = 4,
    MAVEN_LATE_SUMMARY = 8,
    MAVEN_LATE_GOING_OUT_SCORE = 14,
    MAVEN_LATE_MOVE = 16,
    MAVEN_LATE_REQUIREMENT_LIST = 50,
    MAVEN_LATE_REQUIRED_MASK = 54,
    MAVEN_LATE_MULTIPLICITY = 56,
    MAVEN_LATE_REMAINING_LEAVE = 58,
    MAVEN_LATE_USED_TILES = 60,
    MAVEN_LATE_PRIORITY_COUNTS = 61,
    MAVEN_LATE_RECORD_SIZE = 66,
    MAVEN_LATE_CAPACITY = 90
};
typedef struct {
    uint8_t records[90][66];
    uint16_t count;
    uint32_t cutoff_bits;
    /* Cached physical array slots, not stable record identifiers. Negative
     * values represent pointers outside this pool. Slot0 deliberately misses
     * the original fast-path strict lower-bound test. */
    int16_t column_cache[16];
    uint16_t unseen_count;
    uint32_t aggregate_leave_bits;
    uint16_t letter_leave[128], letter_values[128];
    int16_t per_tile_adjustment;
    uint8_t priority_letters[4]; /* Original fields -828,-82c,-826,-82a. */
    uint8_t distinct_letters[28];
    uint8_t available[128];
} MavenLatePool;
/* CODE36+133a: sum unconsumed tile leave values using original word products. */
uint32_t maven_late_remaining_leave(const MavenLatePool *, const uint8_t used[128]);
/* CODE36+1376: match geometry, new-tile count and four priority counts;
 * increase score with stable insertion. Returns the possibly moved array slot
 * or -1. Cache entries retain physical slots even when records shift. */
int16_t maven_late_match_reply(MavenLatePool *, const uint8_t move[34], uint16_t new_tiles,
                               const uint8_t priority_counts[4], uint32_t score_bits);
/* CODE36+6de: select up to90 initial pool replies. More-than7 tile candidates
 * are rejected here, after their original generator callback was emitted. */
void maven_select_late_pool_reply(MavenLatePool *, const uint8_t move[34], uint16_t new_tiles,
                                  const uint8_t used[128]);
/* CODE36+4: multiplicity of this physical tile selection, plus its special
 * blank/bingo adjustment. bitmap is optional, sized1<<unseen_count. This
 * helper clears used counts for letters appearing in the word, as original.
 * blank_masks are occurrence row63, not a separate invented mask table. */
uint16_t maven_late_reply_multiplicity(const MavenLatePool *, const uint8_t move[34],
                                       uint16_t new_tiles, uint8_t used[128], const uint8_t *board,
                                       const uint16_t occurrences[128][8],
                                       const uint16_t choose[][8], uint8_t *bitmap, uint16_t tag);
/* CODE36+4da second pass. The original fast path reads four bytes through
 * inherited A2 before assigning its cached-record pointer. Supply those
 * observed bytes in record priority order; NULL disables that fast test.
 * This ABI dependency is preserved explicitly pending broader trace coverage.
 * Generator A2 usually points after the board span, but blank arbitration
 * can leave it at an earlier square (see late_search.c's inherited_bytes). */
void maven_merge_late_pool_reply(MavenLatePool *, const uint8_t move[34], uint16_t new_tiles,
                                 uint8_t used[128], const uint8_t *board,
                                 const uint16_t occurrences[128][8], const uint16_t choose[][8],
                                 uint8_t *bitmap, const uint8_t inherited_priority[4]);
/* CODE36+18c: refine the fixed90-record local pool. Stable identifiers
 * occupy move adjustment bytes+24..27 while this workspace is active. */
void maven_refine_late_pool_reply(MavenLatePool *, const uint8_t move[34], uint16_t new_tiles,
                                  uint8_t used[128], const uint8_t *board,
                                  const uint16_t occurrences[128][8], const uint16_t choose[][8],
                                  uint8_t *bitmap);
#endif
