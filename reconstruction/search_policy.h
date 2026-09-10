#ifndef MAVEN_SEARCH_POLICY_H
#define MAVEN_SEARCH_POLICY_H
#include <stdint.h>
typedef enum { MAVEN_SEARCH_HEURISTIC, MAVEN_SEARCH_ENDGAME, MAVEN_SEARCH_LATE } MavenSearchKind;
/* CODE3[0x1fa,0x242): total is narrowed to a byte before mixed signed and
 * unsigned tests. Intended legal game total0..100; enable flags are original
 * simulation-config words at +0x14 and +0x12. */
MavenSearchKind maven_choose_search_kind(int16_t unseen_total, int endgame_enabled,
                                         int late_enabled);
#endif
