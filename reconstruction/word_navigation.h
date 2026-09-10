#ifndef MAVEN_WORD_NAVIGATION_H
#define MAVEN_WORD_NAVIGATION_H
#include <stdint.h>
typedef struct {
    void *user;
    void (*lock_text)(void *user);
    void (*unlock_text)(void *user);
    int16_t (*text_length)(void *user);
    uint8_t (*is_separator)(void *user, int16_t index);
} MavenWordNavigationOps;
/* CODE 9+0x3fe..0x46c. Observed callers supply direction -1 or +1.
 * No upper clamp; predicates may inspect one index beyond the loop bounds. */
int16_t maven_find_word_edge(const MavenWordNavigationOps *ops, int16_t position,
                             int16_t direction);
#endif
