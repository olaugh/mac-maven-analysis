#include "endgame_move_cache.h"
#include <stddef.h>
#include <string.h>
static uint32_t read_long(const uint8_t *p) {
    return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3];
}
static int64_t signed_long(uint32_t x) {
    return x <= INT32_MAX ? x : (int64_t)x - INT64_C(4294967296);
}
static int accept_all(void *user, const uint8_t *move) {
    (void)user;
    (void)move;
    return 1;
}
static int accept_improvement(void *user, const uint8_t *move) {
    return maven_accept_endgame_placement_improvement(user, move);
}
void maven_summarize_reply(MavenReplySummary *summary, const uint8_t move[34]) {
    summary->score_bits = read_long(move + 16);
    summary->emptied_rack = move[29];
    summary->kept_mask = move[31];
    summary->row = move[32];
    summary->column = move[33];
    summary->length = (uint8_t)strlen((const char *)move);
}
int maven_reply_same_placement(const MavenReplySummary *a, const MavenReplySummary *b) {
    return a->kept_mask == b->kept_mask && a->row == b->row && a->column == b->column &&
           a->length == b->length;
}
void maven_link_reply_summaries(MavenEndgameMoveCache *cache, const MavenCandidateList *ranking) {
    int i;
    unsigned count = 0;
    cache->first = -1;
    for (i = 255; i >= 0; --i)
        if (cache->replies[i].row) {
            cache->replies[i].identifier = (uint8_t)count++;
            cache->replies[i].next = cache->first;
            cache->first = (int16_t)i;
        }
    for (i = 0; i < ranking->count && count < 256; ++i) {
        MavenReplySummary *summary = &cache->replies[256 + i];
        maven_summarize_reply(summary, ranking->moves[i]);
        if (!maven_reply_same_placement(summary, &cache->replies[2 * summary->kept_mask]) &&
            !maven_reply_same_placement(summary, &cache->replies[2 * summary->kept_mask + 1])) {
            summary->identifier = (uint8_t)count++;
            summary->next = cache->first;
            cache->first = (int16_t)(256 + i);
        }
    }
    cache->summary_count = (uint16_t)count;
}
void maven_cache_own_endgame_move(MavenEndgameMoveCache *cache, MavenCandidateList *ranking,
                                  const uint8_t move[34]) {
    uint32_t score = read_long(move + 16);
    unsigned mask = move[31];
    if (signed_long(score) > signed_long(cache->best[mask])) {
        cache->second[mask] = cache->best[mask];
        cache->best[mask] = score;
    } else if (signed_long(score) > signed_long(cache->second[mask]))
        cache->second[mask] = score;
    maven_insert_ranked_candidate(ranking, move, accept_all, NULL);
}
void maven_cache_opponent_endgame_move(MavenEndgameMoveCache *cache, MavenCandidateList *ranking,
                                       uint8_t move[34]) {
    uint32_t score = read_long(move + 16);
    unsigned mask = move[31];
    if (signed_long(score) > signed_long(cache->best[mask])) {
        cache->replies[2 * mask + 1] = cache->replies[2 * mask];
        maven_summarize_reply(&cache->replies[2 * mask], move);
        cache->second[mask] = cache->best[mask];
        cache->best[mask] = score;
    } else if (signed_long(score) > signed_long(cache->second[mask])) {
        cache->second[mask] = score;
        maven_summarize_reply(&cache->replies[2 * mask + 1], move);
    }
    if (move[28] || move[29]) {
        memset(move + 20, 0, 3);
        move[23] = 20;
    }
    maven_insert_ranked_candidate(ranking, move, accept_improvement, ranking);
}
int maven_accept_endgame_placement_improvement(MavenCandidateList *ranking,
                                               const uint8_t move[34]) {
    unsigned i;
    for (i = 0; i < ranking->count; ++i) {
        const uint8_t *old = ranking->moves[i];
        if (memcmp(old + 30, move + 30, 4))
            continue;
        if (signed_long(read_long(move + 16) + read_long(move + 20)) <=
            signed_long(read_long(old + 16) + read_long(old + 20)))
            return 0;
        --ranking->count;
        memmove(ranking->moves[i], ranking->moves[i + 1], 34 * (ranking->count - i));
        break;
    }
    return 1;
}
