#ifndef MAVEN_ENDGAME_RACK_BOUNDS_H
#define MAVEN_ENDGAME_RACK_BOUNDS_H
#include <stdint.h>
/* CODE39 prepared128-mask, nine-word rows. Field names identify their role
 * in the recurrence; preparation by CODE39+190 remains separately recovered. */
typedef struct {
    const uint16_t (*own_a)[9], (*own_b)[9], (*own_error)[9];
    const uint16_t (*other_a)[9], (*other_b)[9], (*other_error)[9];
} MavenEndgameRackBounds;
/* CODE39[51a,576), [576,68c), [68c,6fc). All arithmetic narrows to words
 * before signed comparisons, including output correction terms. */
int16_t maven_bound_own_rack(void *state, int16_t own, int16_t *positive, int16_t *negative);
int16_t maven_bound_paired_racks_base(const MavenEndgameRackBounds *state, int16_t own,
                                      int16_t other, int16_t *positive, int16_t *negative);
int16_t maven_bound_paired_racks(void *state, int16_t own, int16_t other, int16_t *positive,
                                 int16_t *negative);
/* CODE39[0x1cc,0x512), after CODE43+1dc has adjusted per-mask scores.
 * Prepares one side's three tables; untouched noncanonical rows retain bytes.
 * Valid original canonical masks and sorted rack<=7. Returns number of depth
 * rows computed before convergence; it is a port diagnostic, not guest D0. */
unsigned maven_prepare_endgame_rack_bounds(uint16_t a[128][9], uint16_t b[128][9],
                                           uint16_t error[128][9], const uint8_t *sorted_rack,
                                           const uint16_t *canonical_masks, unsigned mask_count,
                                           const uint16_t tile_points[128],
                                           const uint32_t best[128], const uint32_t second[128],
                                           void (*diagnostic)(void *), void *user);
/* CODE43[0x1dc,0x314), with blank substitutions[0xba,0x1dc).
 * Reindexes kept-mask move scores into played-mask scores, propagates blank
 * replacements, and converts runner-up scores into uncertainty margins. */
void maven_prepare_endgame_mask_scores(uint32_t best[128], uint32_t second[128],
                                       const uint8_t *sorted_rack, const uint16_t *canonical_masks,
                                       unsigned mask_count, const uint16_t tile_points[128],
                                       const uint16_t letter_values[128],
                                       const uint16_t occurrence_masks[128][8],
                                       void (*diagnostic)(void *), void *user);
/* CODE39[0x4,0x190): correction from local move scores after a candidate.
 * Outputs signed longs initialized to zero. selected_mask is written only
 * when the propagation correction strictly improves. Depths are1..8. */
void maven_endgame_local_score_corrections(const MavenEndgameRackBounds *state, uint8_t kept_mask,
                                           int16_t move_score, const uint8_t *sorted_rack,
                                           const uint16_t *canonical_masks, unsigned mask_count,
                                           const uint32_t best_scores[128], int16_t first_depth,
                                           int16_t second_depth, int32_t *lower_correction,
                                           int32_t *propagation_correction, uint16_t *selected_mask,
                                           void (*diagnostic)(void *), void *user);
#endif
