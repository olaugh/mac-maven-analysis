#ifndef MAVEN_LATE_PREPARATION_H
#define MAVEN_LATE_PREPARATION_H
#include "apply_move.h"
#include "late_pool_select.h"
#include "pattern_match.h"
typedef struct {
    MavenLatePool *pool;
    MavenApplyState *application;
    uint8_t *pool_rack; /* At least17 bytes. */
    MavenPatternMatchInput patterns;
    uint16_t draw_multiplicity[8], total_weight;
    uint32_t bingo_bonus;
    /* Serialization token only, never dereferenced. Zero emits byte offsets;
     * a guest base permits byte-exact original trace comparison. */
    uint32_t serialized_record_base;
    void (*pattern_value)(void *, unsigned record_index, uint32_t value);
    void *user;
} MavenLatePreparation;
/* CODE36+14d0: summarize each reply, apply it to score board-only patterns,
 * restore the position, sort and link all66-byte descriptors. Explicit pool,
 * counts and undo/scorer state retain the original side effects. */
void maven_prepare_late_pool_replies(MavenLatePreparation *);
#endif
