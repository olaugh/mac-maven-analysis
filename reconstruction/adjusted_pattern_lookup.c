#include "adjusted_pattern_lookup.h"
#include "letter_expectation.h"
#include <string.h>
static int16_t signed_byte(uint8_t x) {
    return x < 128 ? x : (int16_t)x - 256;
}
int16_t maven_lookup_pattern_with_letter_expectation(
    MavenPatternEntry *entries, int16_t count, const uint8_t *letters, const uint8_t *score_records,
    uint32_t **accumulator, int16_t unseen_total, const uint8_t unseen_counts[128],
    const uint8_t distribution[128], const uint32_t letter_scores[27][8]) {
    uint16_t score =
        (uint16_t)maven_lookup_pattern(entries, count, letters, score_records, accumulator);
    if (strlen((const char *)letters) == 1) {
        uint8_t letter = letters[0];
        unsigned index = letter == '?' ? 0 : letter - 'a' + 1;
        score = (uint16_t)(score + maven_letter_expectation(unseen_total,
                                                            signed_byte(unseen_counts[letter]),
                                                            letter_scores[index]));
        score = (uint16_t)(score - maven_letter_expectation(
                                       96, (int16_t)(signed_byte(distribution[letter]) - 1),
                                       letter_scores[index]));
    }
    return score < 32768 ? (int16_t)score : (int16_t)((int32_t)score - 65536);
}
