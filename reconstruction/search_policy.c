#include "search_policy.h"
MavenSearchKind maven_choose_search_kind(int16_t total, int endgame, int late) {
    uint8_t bits = (uint8_t)total;
    int16_t signed_total = bits < 128 ? bits : (int16_t)bits - 256;
    if (signed_total < 8 && endgame)
        return MAVEN_SEARCH_ENDGAME;
    if (signed_total > 7 && bits < 17 && late)
        return MAVEN_SEARCH_LATE;
    return MAVEN_SEARCH_HEURISTIC;
}
