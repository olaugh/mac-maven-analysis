#ifndef MAVEN_HISTORY_PLAYBACK_H
#define MAVEN_HISTORY_PLAYBACK_H
#include "history_records.h"
#include "apply_move.h"
typedef struct {
    MavenApplyState *application;
    uint8_t *racks[2];
    uint32_t totals[2];
    int selected_side;
    const uint8_t *display_order; /* prfs+0x312: original puts blank LAST. */
    const MavenHistoryRecord *records;
    size_t count;
    /* CODE22+048a /CODE31+07e0, using actual recovered refill and external
     * RNG/ticks. Return0 on host failure;1 on completion. No recorded rack
     * outcome is required. UI refresh before refill is outside this API. */
    int (*refill)(void *,unsigned side);
    void (*checkpoint)(void *,size_t index,int tag);
    void *user;
    size_t restored_index;
} MavenHistoryPlayback;
typedef enum { MAVEN_PLAYBACK_OK, MAVEN_PLAYBACK_INVALID,
               MAVEN_PLAYBACK_REFILL_FAILED } MavenPlaybackResult;
/* CODE7+0590/+003c computational history traversal, then+0004 selection reset and selected-rack recount/sort.
 * Iterates from the closest tag0/1 base, equivalent to original recursion for
 * supported tags0..4. Tag2 applies a move and refills; tag3 sets final score
 * and clears both racks; tag4 is a history marker. Unknown tags are rejected.
 * Initialization/scoring tables must already be valid. A malformed later move
 * or refill failure leaves partial state; callers must inspect the result.
 * Cache/UI state is not rebuilt, and no new history records are appended.
 * Repeating with an older index supplies the restore portion of undo. */
MavenPlaybackResult maven_restore_history_index(MavenHistoryPlayback *,size_t index);
/* CODE7+492: after restoring the preceding position, prepare the selected
 * history record for user continuation. Tag2 restores its recorded racks
 * (not the random replay refills), swaps totals for an opponent record, and
 * puts the mover in rack0. Tag3 clears racks and sets selected_side=2. */
MavenPlaybackResult maven_prepare_history_selection(MavenHistoryPlayback *state,size_t selected_index);
#endif
