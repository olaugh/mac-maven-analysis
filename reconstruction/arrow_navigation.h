#ifndef MAVEN_ARROW_NAVIGATION_H
#define MAVEN_ARROW_NAVIGATION_H
#include <stdint.h>
typedef struct {
    void *user;
    int16_t (*start)(void *);
    int16_t (*end)(void *);
    void (*select)(void *, int32_t start, int32_t end);
    void (*lock)(void *);
    void (*unlock)(void *);
    uint8_t (*separator)(void *, int16_t);
    int16_t (*word_edge)(void *, int16_t, int16_t);
} MavenArrowOps;
/* CODE 9+0x4f0..0x742. Selection callbacks must expose updated values.
 * Word-edge itself locks/unlocks: nested locks are deliberately retained. */
int16_t maven_arrow_navigation(const MavenArrowOps *, uint8_t, uint16_t);
#endif
