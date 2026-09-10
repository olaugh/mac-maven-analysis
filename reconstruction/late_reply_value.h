#ifndef MAVEN_LATE_REPLY_VALUE_H
#define MAVEN_LATE_REPLY_VALUE_H
#include <stdint.h>
/* CODE36+91e's explicit evaluator state, including unseen-Q expectations.
 * Score tables are original signed words: preserve their supplied bit patterns. */
typedef struct {
    uint16_t unseen_count, own_remaining, other_remaining, bag_remaining;
    uint16_t unseen_q, new_tiles, main_triple;
    uint8_t available[128], used[128];
    uint16_t leave[128], tile_points[128], letter_leave[128];
    uint16_t normal_bag[10], held_q_bag[10], reply_q_bag[10];
    uint16_t normal_empty_bag[8][8], held_q_no_u[8][8], held_q_with_u[8][8];
    uint16_t blank_adjustment[8][8];
    uint16_t normal_before_matrix, with_u_before_matrix;
    uint16_t (*blank_query)(void *);
    void *user;
    uint16_t opponent_held_q[8][8]; /* A5-6294 */
    uint16_t held_u_value;          /* raw qu lookup, A5-792 */
} MavenLateReplyValue;
/* Writes zero to move.leave (+20), matching the original side effect.
 * Returns1 and writes result when unseen_q==0. Returns0 without mutation when
 * unseen_q is nonzero; use the complete entry point below for that case. Rack/bag counts are restored on return. */
int maven_value_late_reply_without_unseen_q(MavenLateReplyValue *, uint8_t move[34],
                                            const uint8_t reply[66], uint32_t *result_bits);
/* Complete CODE36[0x91e,0x113a) computational valuation, including both
 * large-pool Q branches and row-zero exchanges. Valid original rack/table
 * domains and nonzero denominators required. Acceptance coverage is recorded
 * separately; the original Q/held-blank discarded-result oddity is retained. */
int maven_value_late_reply(MavenLateReplyValue *, uint8_t move[34], const uint8_t reply[66],
                           uint32_t *result_bits);
#endif
