#ifndef MAVEN_DISPLAY_MOVE_SCORE_H
#define MAVEN_DISPLAY_MOVE_SCORE_H
#include "apply_move.h"
/* CODE8[4,0x374): score a staged display move, update its private metadata,
 * and replace application scorer globals. Display is the original17x17
 * grid; classes has256 entries so encoded blank characters are supported.
 * This follows explicit displayed blank placement instead of choosing a
 * blank assignment. Valid bounded ASCII move/coordinates required. */
typedef struct {
    MavenApplyState *application;
    const uint8_t *display;
    const uint8_t *classes;
    const uint8_t *own_rack;
} MavenDisplayMoveScore;
void maven_score_display_move(void *context, uint8_t move[34]);
#endif
