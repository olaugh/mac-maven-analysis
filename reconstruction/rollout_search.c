#include "rollout_search.h"
#include "board_state.h"
#include "rack_counts.h"
#include <string.h>
static uint32_t read_long(const uint8_t *p) {
    return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3];
}
static void write_long(uint8_t *p, uint32_t x) {
    p[0] = (uint8_t)(x >> 24);
    p[1] = (uint8_t)(x >> 16);
    p[2] = (uint8_t)(x >> 8);
    p[3] = (uint8_t)x;
}
static int64_t signed_long(uint32_t x) {
    return x <= INT32_MAX ? x : (int64_t)x - INT64_C(4294967296);
}
static int16_t signed_word(uint16_t x) {
    return x < 32768 ? (int16_t)x : (int16_t)((int32_t)x - 65536);
}
static uint16_t points(const uint8_t *rack, const uint16_t *values) {
    uint16_t n = 0;
    for (; *rack; ++rack)
        n = (uint16_t)(n + values[*rack]);
    return n;
}
static int ended(const MavenRolloutSearch *state) {
    return maven_game_end_check(state->racks[0], state->racks[1],
                                state->application->row_zero_count,
                                state->application->placement.board);
}
static void observe(MavenRolloutSearch *s, MavenRolloutEvent kind, unsigned candidate,
                    unsigned reply) {
    if (s->observe)
        s->observe(s->user, kind, candidate, reply);
}
int maven_run_rollout_batch_checked(MavenRolloutSearch *s, const uint8_t *sample, uint32_t weight) {
    MavenApplyState *app = s->application;
    uint8_t board[544], racks[2][8];
    uint16_t values[544];
    unsigned i;
    memcpy(board, app->placement.board, sizeof board);
    memcpy(values, app->placement.values, sizeof values);
    strcpy((char *)racks[0], (const char *)s->racks[0]);
    strcpy((char *)racks[1], (const char *)s->racks[1]);
    for (i = 0; i < s->count; ++i) {
        uint8_t *entry = s->entries + 46 * i;
        uint32_t scores[2] = {0, 0}, leaves[2] = {0, 0};
        unsigned reply = 0;
        int side = 1;
        write_long(entry + 42, read_long(entry + 42) + weight);
        maven_count_rack(app->placement.counts, app->alphabet, s->racks[0]);
        maven_apply_move_without_evaluation(entry, s->racks[0], app);
        observe(s, MAVEN_ROLLOUT_CANDIDATE_APPLIED, i, reply);
        scores[0] += read_long(entry + 16);
        leaves[0] = read_long(entry + 20);
        strcpy((char *)s->racks[1], (const char *)sample);
        s->refill(s->user, 0);
        observe(s, MAVEN_ROLLOUT_CANDIDATE_REFILLED, i, reply);
        for (; reply < (unsigned)s->reply_plies && !ended(s); ++reply) {
            s->selected_side = side;
            s->select(s->user, side, s->selected_move);
            observe(s, MAVEN_ROLLOUT_REPLY_SELECTED, i, reply);
            maven_apply_move_without_evaluation(s->selected_move, s->racks[side], app);
            observe(s, MAVEN_ROLLOUT_REPLY_APPLIED, i, reply);
            s->refill(s->user, side);
            observe(s, MAVEN_ROLLOUT_REPLY_REFILLED, i, reply);
            scores[side] += read_long(s->selected_move + 16);
            leaves[side] = read_long(s->selected_move + 20);
            side = 1 - side;
            if (s->poll)
                s->poll(s->user);
            if (s->cancelled && s->cancelled(s->user))
                return 0;
        }
        if (!ended(s)) {
            scores[0] += leaves[0];
            scores[1] += leaves[1];
        } else if (!s->racks[1][0])
            scores[1] += (uint32_t)(int32_t)signed_word(
                (uint16_t)(2 * points(s->racks[0], app->placement.letter_values)));
        else if (!s->racks[0][0])
            scores[0] += (uint32_t)(int32_t)signed_word(
                (uint16_t)(2 * points(s->racks[1], app->placement.letter_values)));
        else {
            scores[1] +=
                (uint32_t)(int32_t)signed_word(points(s->racks[0], app->placement.letter_values));
            scores[0] +=
                (uint32_t)(int32_t)signed_word(points(s->racks[1], app->placement.letter_values));
        }
        write_long(entry + 34, read_long(entry + 34) + (scores[0] - scores[1]) * weight);
        if (signed_long(scores[0]) > signed_long(scores[1]))
            write_long(entry + 38, read_long(entry + 38) + 2 * weight);
        else if (scores[0] == scores[1])
            write_long(entry + 38, read_long(entry + 38) + weight);
        memcpy(app->placement.board, board, sizeof board);
        memcpy(app->placement.values, values, sizeof values);
        strcpy((char *)s->racks[0], (const char *)racks[0]);
        observe(s, MAVEN_ROLLOUT_CANDIDATE_RESTORED, i, reply);
    }
    strcpy((char *)s->racks[1], (const char *)racks[1]);
    return 1;
}
void maven_run_rollout_batch(MavenRolloutSearch *s, const uint8_t *sample, uint32_t weight) {
    (void)maven_run_rollout_batch_checked(s, sample, weight);
}
