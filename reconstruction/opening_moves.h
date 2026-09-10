#ifndef MAVEN_OPENING_MOVES_H
#define MAVEN_OPENING_MOVES_H
#include "opening_placements.h"
#include "score_move.h"

typedef struct {
    MavenOpeningEnumeration enumeration;
    MavenScoreInput scoring;
    const uint8_t *sorted_rack;
    const uint16_t *leave_values; /* 128 original leave-table words, native endian. */
    void (*move)(void *user, const uint8_t move[34]);
    void *user;
} MavenOpeningMoves;

/* Opening-only integration of recovered CODE37 traversal with earlier-section
 * duplicate suppression, CODE32 scorer and CODE37 move fields. Produces the
 * pre-ranking callback stream. Legal seven-tile rack/empty-board contracts;
 * leave_values is a supplied precomputed boundary, not recovered here.
 * Reuses the verified general scorer rather than claiming a literal recovery
 * of CODE37's optimized evaluator and all its transient globals. */
void maven_generate_opening_moves(MavenOpeningMoves *state);
#endif
