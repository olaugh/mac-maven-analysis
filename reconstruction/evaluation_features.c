#include "evaluation_features.h"
#include <string.h>
static int16_t signed_byte(uint8_t x) {
    return x < 128 ? x : (int16_t)x - 256;
}
static int16_t signed_word(uint16_t x) {
    return x < 32768 ? (int16_t)x : (int16_t)((int32_t)x - 65536);
}
MavenEvaluationBefore maven_prepare_evaluation_features(uint32_t f[22], const uint8_t counts[128],
                                                        uint32_t rack_length,
                                                        int16_t (*is_vowel)(void *, int16_t),
                                                        void *user) {
    int16_t vowels = 0, consonants = 0, letter;
    MavenEvaluationBefore b = {signed_byte(counts['j']), signed_byte(counts['q']),
                               signed_byte(counts['x']), signed_byte(counts['z']),
                               signed_byte(counts['?']), signed_word((uint16_t)rack_length)};
    memset(f, 0, 88);
    for (letter = 'a'; letter <= 'z'; ++letter) {
        int16_t count = signed_byte(counts[letter]);
        if (!count)
            continue;
        if (is_vowel(user, letter))
            vowels = signed_word((uint16_t)(vowels + count));
        else
            consonants = signed_word((uint16_t)(consonants + count));
        if (count >= 3)
            ++f[MAVEN_FEATURE_TRIPLES];
        else if (letter != 's' && count == 2)
            ++f[MAVEN_FEATURE_PAIRS_EXCEPT_S];
    }
    if (vowels >= 6)
        f[MAVEN_FEATURE_MANY_VOWELS] = 1;
    else if (consonants >= 6)
        f[MAVEN_FEATURE_MANY_CONSONANTS] = 1;
    return b;
}
void maven_finish_evaluation_features(uint32_t f[22], const MavenEvaluationBefore *b,
                                      const uint8_t counts[128], uint32_t move_score,
                                      int16_t occupied_before, const uint8_t *remaining,
                                      int16_t special_score, const uint16_t *ids,
                                      const uint16_t *weights, int16_t (*matches)(void *, int16_t),
                                      void *user) {
    if (signed_byte(counts['j']) != b->j)
        f[MAVEN_FEATURE_J_SCORE] = move_score;
    if (signed_byte(counts['q']) != b->q)
        f[MAVEN_FEATURE_Q_SCORE] = move_score;
    if (signed_byte(counts['x']) != b->x)
        f[MAVEN_FEATURE_X_SCORE] = move_score;
    if (signed_byte(counts['z']) != b->z)
        f[MAVEN_FEATURE_Z_SCORE] = move_score;
    if (signed_byte(counts['?']) != b->blank)
        f[MAVEN_FEATURE_BLANK_SCORE] = move_score;
    f[MAVEN_FEATURE_CONSTANT] = 1;
    if (occupied_before >= 86)
        f[MAVEN_FEATURE_END_SCORE] = move_score;
    else if (occupied_before >= 77)
        f[MAVEN_FEATURE_LATE_SCORE] = move_score;
    else if (occupied_before >= 30)
        f[MAVEN_FEATURE_MIDDLE_SCORE] = move_score;
    else
        f[MAVEN_FEATURE_EARLY_SCORE] = move_score;
    if (!strlen((const char *)remaining) && b->rack_length == 7 &&
        !(move_score & UINT32_C(0x80000000)) && move_score >= 5000) {
        f[MAVEN_FEATURE_BINGO_SCORE] = move_score;
        f[MAVEN_FEATURE_BINGO_FLAG] = 1;
    }
    f[MAVEN_FEATURE_PRIOR_Q] = (uint32_t)(int32_t)b->q;
    f[MAVEN_FEATURE_PRIOR_BLANK] = (uint32_t)(int32_t)b->blank;
    if (special_score) {
        f[MAVEN_FEATURE_SPECIAL_SCORE] = (uint32_t)(int32_t)special_score;
        f[MAVEN_FEATURE_SPECIAL_FLAG] = 1;
    }
    while (*ids) {
        if (matches(user, signed_word(*ids)))
            f[MAVEN_FEATURE_MATCHED_WEIGHT] += (uint32_t)(int32_t)signed_word(*weights);
        ++ids;
        ++weights;
    }
}

int16_t maven_evaluation_record_flag_clear(const uint8_t *records, int16_t count, int16_t id) {
    if (id < 0)
        return 1;
    if (id >= count)
        return 0;
    return records[(uint32_t)id * 8 + 6] == 0;
}

int16_t maven_evaluation_record_flag_set(const uint8_t *records, int16_t count, int16_t id) {
    if (id <= 0 || id >= count)
        return 0;
    return records[(uint32_t)id * 8 + 6] != 0;
}
