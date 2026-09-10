#include "late_reply_value.h"
#include <string.h>
static uint32_t read32(const uint8_t *p) {
    return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3];
}
static uint16_t read16(const uint8_t *p) { return (uint16_t)((uint16_t)p[0] << 8 | p[1]); }
static int32_t signed32(uint32_t x) {
    return x < UINT32_C(0x80000000) ? (int32_t)x : (int32_t)((int64_t)x - INT64_C(0x100000000));
}
static int32_t word(uint16_t x) { return x < 32768 ? x : (int32_t)x - 65536; }
static uint32_t divide(uint32_t x, unsigned n) { return (uint32_t)(signed32(x) / (int32_t)n); }
static unsigned minimum(unsigned a, unsigned b) { return a < b ? a : b; }
/* CODE36+ab8 and+d88: expectation when a Q may remain in a larger bag.
 * The placement branch deliberately truncates each leave product to a word;
 * the exchange branch uses long products. */
static uint32_t large_unseen_q(MavenLateReplyValue *s, const uint8_t move[34],
                               const uint8_t reply[66], unsigned bag, unsigned own_draw,
                               unsigned reply_draw, int exchange) {
    uint32_t reply_score = read32(reply + 32), average7, average6, adjusted, held, threshold,
             alternate;
    unsigned denominator = exchange ? s->unseen_count + s->new_tiles - 1 : s->unseen_count - 1;
    uint32_t q_leave = (uint32_t)word(s->letter_leave['q']);
    if (exchange) {
        adjusted = (uint32_t)word(read16(reply + 58)) - q_leave;
        average7 = divide(adjusted * 7u, denominator);
        average6 = divide(adjusted * 6u, denominator);
    } else {
        int32_t remaining = word((uint16_t)(read16(reply + 58) - s->letter_leave['q']));
        average7 = divide((uint32_t)word((uint16_t)(remaining * 7)), denominator);
        average6 = divide((uint32_t)word((uint16_t)(remaining * 6)), denominator);
    }
    held = 0u - reply_score + (uint32_t)word(s->held_q_bag[bag]);
    if (s->available['u'] != s->used['u'])
        held += (uint32_t)word(s->held_u_value);
    adjusted = (held - average7) * own_draw;
    threshold = average7 - divide(q_leave, exchange ? s->unseen_count : bag + reply_draw);
    alternate = reply_score + average6 - (uint32_t)word(s->reply_q_bag[bag]);
    if (signed32(alternate) > signed32(threshold))
        threshold = alternate;
    adjusted -= threshold * (7u - reply_draw);
    adjusted += (0u - reply_score - average7 + (uint32_t)word(s->reply_q_bag[bag])) * reply_draw;
    return (uint32_t)word(s->leave[read16(move + 30)]) + divide(adjusted, own_draw + 7);
}
int maven_value_late_reply(MavenLateReplyValue *s, uint8_t move[34], const uint8_t reply[66],
                           uint32_t *result) {
    uint16_t mask = read16(move + 30);
    unsigned own = s->own_remaining, other = s->other_remaining, bag = s->bag_remaining;
    unsigned reply_tiles = reply[60], own_draw, reply_draw, remaining_pool;
    uint32_t value, remaining_leave;

    memset(move + 20, 0, 4);
    value = (uint32_t)word(s->leave[mask]);
    if (!move[32]) {
        unsigned i;
        uint32_t spent_leave = 0, expected, adjustment;
        value -= read32(reply + 32);
        value -= read32(reply + 36);
        reply_draw = minimum(reply_tiles, bag);
        bag -= reply_draw;
        other -= reply_tiles - reply_draw;
        for (i = 0; move[i]; ++i)
            if (move[i] != 'q' && move[i] != move[i + 1])
                spent_leave +=
                    (uint32_t)word((uint16_t)(s->used[move[i]] * word(s->letter_leave[move[i]])));
        remaining_leave = (uint32_t)word(read16(reply + 58));
        if (s->unseen_q && !reply[62])
            remaining_leave -= (uint32_t)word(s->letter_leave['q']);
        remaining_pool = s->unseen_count - reply_tiles;
        expected = divide(remaining_leave * other, remaining_pool);
        adjustment = spent_leave - divide(remaining_leave * s->new_tiles, remaining_pool);
        value -= expected + divide(adjustment * reply_draw, s->unseen_count - 7);
        if (s->used['q']) {
            int32_t normal = word(bag ? s->normal_bag[bag] : s->normal_before_matrix);
            int32_t played_q = word(bag ? s->reply_q_bag[bag] : s->with_u_before_matrix);
            adjustment = (uint32_t)word(
                (uint16_t)((remaining_pool - reply_draw) * normal + reply_draw * played_q));
            value += divide(adjustment, remaining_pool);
        } else if (s->unseen_q && !reply[62]) {
            if (s->unseen_count > 13) {
                *result = large_unseen_q(s, move, reply, bag, s->new_tiles, reply_draw, 1);
                return 1;
            }
            uint32_t held = (uint32_t)word(s->held_q_bag[bag]);
            if (s->available['u'] != s->used['u'])
                held += (uint32_t)word(s->held_u_value);
            value += divide(held * s->new_tiles + 7u * (uint32_t)word(s->reply_q_bag[bag]),
                            s->new_tiles + 7);
        } else
            value += (uint32_t)word(s->available['q'] != s->used['q'] ? s->held_q_bag[bag]
                                                                      : s->normal_bag[bag]);
        *result = value;
        return 1;
    }
    if (reply_tiles == 7 && s->unseen_count - 7 <= s->new_tiles) {
        int32_t shifted = word(s->leave[mask]);
        /* Defined arithmetic right shift, including negative nonmultiples. */
        shifted = shifted >= 0 ? shifted / 128 : -((-shifted + 127) / 128);
        *result = (uint32_t)shifted -
                  (uint32_t)(word(read16(reply + 14)) + word((uint16_t)(2 * s->tile_points[mask])));
        return 1;
    }
    if (read32(reply + 36) && !s->main_triple)
        value -= read32(reply + 36);
    value -= read32(reply + 32);
    own_draw = minimum(s->new_tiles, bag);
    bag -= own_draw;
    own -= s->new_tiles - own_draw;
    if (!bag)
        value -= s->available['?'] != s->used['?'] && own == 7 ? 1200 : 300;
    reply_draw = minimum(reply_tiles, bag);
    bag -= reply_draw;
    other -= reply_tiles - reply_draw;
    remaining_leave = (uint32_t)word(read16(reply + 58));
    remaining_pool = s->unseen_count - reply_tiles;
    if (s->unseen_q && !reply[62]) {
        remaining_leave -= (uint32_t)word(s->letter_leave['q']);
        --remaining_pool;
    }
    value -= divide(remaining_leave * other, remaining_pool);
    if (bag && s->unseen_q && !reply[62]) {
        if ((int)s->unseen_count - 13 > s->new_tiles) {
            *result = large_unseen_q(s, move, reply, bag, own_draw, reply_draw, 0);
            return 1;
        }
        uint32_t held = (uint32_t)word(s->held_q_bag[bag]);
        if (s->available['u'] != s->used['u'])
            held += (uint32_t)word(s->held_u_value);
        value += divide(held * own_draw + 7u * (uint32_t)word(s->reply_q_bag[bag]), own_draw + 7);
    } else if (bag) {
        value += (uint32_t)word(s->available['q'] != s->used['q'] ? s->held_q_bag[bag]
                                                                  : s->normal_bag[bag]);
    } else if (s->unseen_q && !reply[62]) {
        uint32_t own_held, other_held = (uint32_t)word(s->opponent_held_q[own][other]);
        int held_blank = s->available['?'] != s->used['?'];
        if (s->available['u'] != s->used['u'])
            own_held = (uint32_t)word(s->held_q_with_u[own][other]);
        else if (held_blank) {
            own_held = (uint32_t)word(s->held_q_with_u[own][other]);
            if (s->blank_query)
                own_held -= (uint32_t)word(s->blank_query(s->user));
        } else
            own_held = (uint32_t)word(s->held_q_no_u[own][other]);
        if (held_blank) {
            if (s->blank_query)
                other_held -= (uint32_t)word(s->blank_query(s->user));
            other_held += (uint32_t)word(s->blank_adjustment[own][other]);
            if (own == 7)
                value += 1200;
        }
        value += divide(own_held * own_draw + other_held * 5u, own_draw + 5);
    } else if (s->available['q'] != s->used['q']) {
        if (s->available['u'] != s->used['u'])
            value += (uint32_t)word(s->held_q_with_u[own][other]);
        else if (s->available['?'] != s->used['?']) {
            /* CODE36+108c computes this candidate into D4, but +10a4 jumps
             * to restoration without adding D4 to D6. Preserve the observed
             * instruction semantics, including the query call's side effect. */
            if (s->blank_query)
                (void)s->blank_query(s->user);
        } else
            value += (uint32_t)word(s->held_q_no_u[own][other]);
    } else {
        value += (uint32_t)word(s->normal_empty_bag[own][other]);
        if (s->available['?'] != s->used['?']) {
            if (s->blank_query)
                value -= (uint32_t)word(s->blank_query(s->user));
            value += (uint32_t)word(s->blank_adjustment[own][other]);
        }
    }
    *result = value;
    return 1;
}

int maven_value_late_reply_without_unseen_q(MavenLateReplyValue *s, uint8_t move[34],
                                            const uint8_t reply[66], uint32_t *result) {
    if (s->unseen_q)
        return 0;
    return maven_value_late_reply(s, move, reply, result);
}
