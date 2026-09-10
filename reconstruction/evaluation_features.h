#ifndef MAVEN_EVALUATION_FEATURES_H
#define MAVEN_EVALUATION_FEATURES_H
#include <stdint.h>
/* Original long-vector order starting at A5-0x5bc0; semantic labels inferred
 * from assignments. These feed per-player move statistics (CODE11 -> CODE16), not a proven
 * ranking formula. Historical evaluation names are retained for now. */
enum {
    MAVEN_FEATURE_CONSTANT,
    MAVEN_FEATURE_EARLY_SCORE,
    MAVEN_FEATURE_MIDDLE_SCORE,
    MAVEN_FEATURE_LATE_SCORE,
    MAVEN_FEATURE_END_SCORE,
    MAVEN_FEATURE_BINGO_SCORE,
    MAVEN_FEATURE_BINGO_FLAG,
    MAVEN_FEATURE_BLANK_SCORE,
    MAVEN_FEATURE_Q_SCORE,
    MAVEN_FEATURE_X_SCORE,
    MAVEN_FEATURE_J_SCORE,
    MAVEN_FEATURE_Z_SCORE,
    MAVEN_FEATURE_SPECIAL_SCORE,
    MAVEN_FEATURE_SPECIAL_FLAG,
    MAVEN_FEATURE_MATCHED_WEIGHT,
    MAVEN_FEATURE_PAIRS_EXCEPT_S,
    MAVEN_FEATURE_TRIPLES,
    MAVEN_FEATURE_MANY_CONSONANTS,
    MAVEN_FEATURE_MANY_VOWELS,
    MAVEN_FEATURE_PRIOR_Q,
    MAVEN_FEATURE_PRIOR_BLANK,
    MAVEN_FEATURE_ROW_ZERO,
    MAVEN_FEATURE_COUNT
};
typedef struct {
    int16_t j, q, x, z, blank, rack_length;
} MavenEvaluationBefore;
/* CODE31 [0x1b4,0x266), after external CODE35 collection. Valid ASCII rack
 * counts. Classification callback models CODE23+4. Feature arithmetic wraps. */
MavenEvaluationBefore maven_prepare_evaluation_features(uint32_t features[22],
                                                        const uint8_t counts[128],
                                                        uint32_t rack_length,
                                                        int16_t (*is_vowel)(void *, int16_t),
                                                        void *user);
/* CODE31 [0x534,0x63a). Remaining rack is the scorer's output, not the final
 * refilled rack. Original row-zero path can leave it uninitialized: caller
 * must supply its observed value, not silently invent an empty string.
 * record_ids is a zero-terminated word list; weights is parallel. */
void maven_finish_evaluation_features(uint32_t features[22], const MavenEvaluationBefore *before,
                                      const uint8_t counts[128], uint32_t move_score,
                                      int16_t occupied_before, const uint8_t *scored_remaining,
                                      int16_t special_score, const uint16_t *record_ids,
                                      const uint16_t *weights,
                                      int16_t (*record_matches)(void *, int16_t), void *user);
/* CODE35 [0x34,0x64): negative IDs match, out-of-range IDs do not;
 * in-range IDs match exactly when byte6 of their eight-byte record is zero. */
int16_t maven_evaluation_record_flag_clear(const uint8_t *records, int16_t count, int16_t id);
/* CODE35 [4,0x34): flag-set test excludes ID0, unlike flag-clear.
 * It is therefore not the logical negation of the flag-clear predicate. */
int16_t maven_evaluation_record_flag_set(const uint8_t *records, int16_t count, int16_t id);
#endif
