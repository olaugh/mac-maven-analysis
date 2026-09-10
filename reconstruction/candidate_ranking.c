#include "candidate_ranking.h"
#include <string.h>

static uint32_t read_long(const uint8_t *p) {
    return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3];
}
static void write_long(uint8_t *p, uint32_t v) {
    p[0] = (uint8_t)(v >> 24);
    p[1] = (uint8_t)(v >> 16);
    p[2] = (uint8_t)(v >> 8);
    p[3] = (uint8_t)v;
}
static int64_t signed_long(uint32_t v) {
    return v <= INT32_MAX ? (int64_t)v : (int64_t)v - INT64_C(4294967296);
}
uint32_t maven_move_rank_bits(const uint8_t move[34]) {
    return read_long(move + 16) + read_long(move + 20) + read_long(move + 24);
}
int maven_keep_better_move(uint8_t incumbent[34], const uint8_t candidate[34]) {
    if (signed_long(maven_move_rank_bits(incumbent)) >=
        signed_long(maven_move_rank_bits(candidate)))
        return 0;
    memcpy(incumbent, candidate, 34);
    return 1;
}
int maven_rank_sampled_candidates(const uint8_t *entries, size_t count, uint8_t *output) {
    size_t used = 0, index = count;
    uint32_t samples, half;
    if (count > 64)
        return 0;
    if (!count)
        return 1;
    samples = read_long(entries + 42);
    if (!samples)
        samples = 1;
    half = (uint32_t)(signed_long(samples) / 2);
    while (index) {
        uint8_t move[34];
        size_t position = 0;
        const uint8_t *entry = entries + --index * 46;
        uint32_t average =
            (uint32_t)(signed_long(read_long(entry + 34) + half) / signed_long(samples));
        memcpy(move, entry, sizeof move);
        write_long(move + 24, average - read_long(move + 16) - read_long(move + 20));
        while (position < used &&
               signed_long(maven_move_rank_bits(output + position * 34)) > signed_long(average))
            ++position;
        memmove(output + (position + 1) * 34, output + position * 34, (used - position) * 34);
        memcpy(output + position * 34, move, sizeof move);
        ++used;
    }
    return 1;
}

int maven_insert_ranked_candidate(MavenCandidateList *list, const uint8_t candidate[34],
                                  int (*eligible)(void *, const uint8_t *), void *user) {
    uint32_t rank = maven_move_rank_bits(candidate);
    size_t position = 0;
    if (list->count == 10 && signed_long(rank) <= signed_long(list->cutoff_bits))
        return 0;
    if (!eligible(user, candidate))
        return 0;
    while (position < list->count &&
           signed_long(maven_move_rank_bits(list->moves[position])) >= signed_long(rank))
        ++position;
    if (list->count < 10)
        ++list->count;
    memmove(list->moves[position + 1], list->moves[position], (list->count - position - 1) * 34);
    memcpy(list->moves[position], candidate, 34);
    list->cutoff_bits = maven_move_rank_bits(list->moves[9]);
    return 1;
}

int maven_accept_word_improvement(MavenCandidateList *list, const uint8_t candidate[34]) {
    size_t index;
    uint32_t rank = maven_move_rank_bits(candidate);
    for (index = 0; index < list->count; ++index) {
        if (strcmp((const char *)list->moves[index], (const char *)candidate))
            continue;
        if (signed_long(maven_move_rank_bits(list->moves[index])) >= signed_long(rank))
            return 0;
        --list->count;
        memmove(list->moves[index], list->moves[index + 1], (list->count - index) * 34);
        break;
    }
    return 1;
}

int maven_candidate_is_eligible(const uint8_t candidate[34], const uint8_t board[544], int16_t mode,
                                int (*extra_filter)(void *, const uint8_t *), void *user) {
    int row = candidate[32] < 128 ? candidate[32] : (int)candidate[32] - 256;
    int column = candidate[33] < 128 ? candidate[33] : (int)candidate[33] - 256;
    if (mode == 1 && row > 15) {
        const uint8_t *square = board + row * 17 + column;
        while (*square)
            ++square;
        if ((row != 16 && square[-17]) || (row != 30 && square[17]))
            return 0;
    }
    return !extra_filter || extra_filter(user, candidate) != 0;
}
