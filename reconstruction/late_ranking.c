#include "late_ranking.h"
#include <string.h>
static uint32_t read32(const uint8_t *p) {
    return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3];
}
static uint16_t read16(const uint8_t *p) { return (uint16_t)((uint16_t)p[0] << 8 | p[1]); }
static void write32(uint8_t *p, uint32_t x) {
    p[0] = (uint8_t)(x >> 24);
    p[1] = (uint8_t)(x >> 16);
    p[2] = (uint8_t)(x >> 8);
    p[3] = (uint8_t)x;
}
static int32_t signed32(uint32_t x) {
    return x < UINT32_C(0x80000000) ? (int32_t)x : (int32_t)((int64_t)x - INT64_C(0x100000000));
}
static int32_t word(uint16_t x) { return x < 32768 ? x : (int32_t)x - 65536; }
static int deduplicate(void *user, const uint8_t *move) {
    MavenLateRanking *s = user;
    return maven_accept_word_improvement(s->ranking, move);
}
static int eligible(void *user, const uint8_t *move) {
    MavenLateRanking *s = user;
    return maven_candidate_is_eligible(move, s->conflicts->board, (int16_t)s->value->new_tiles,
                                       s->word_deduplication ? deduplicate : NULL, s);
}
static uint32_t value_reply(MavenLateRanking *s, uint8_t *move, const MavenLateRankReply *reply) {
    uint32_t value = 0;
    (void)maven_value_late_reply(s->value, move, reply->record, &value);
    if (s->valuation)
        s->valuation(s->user, move, reply->record, value);
    return value;
}
int maven_rank_late_move(MavenLateRanking *s, uint8_t move[34]) {
    const MavenLateRankReply *baseline = s->baseline, *local = s->local, *reply;
    uint16_t weights[180];
    uint32_t weighted = 0, last_score = s->local_cutoff_bits;
    if (!s->weight_count || s->weight_count > 180 || !s->total_weight)
        return 0;
    memcpy(weights, s->weights, s->weight_count * sizeof(uint16_t));
    maven_clear_reply_conflicts(s->conflicts);
    while (weights[0]) {
        uint32_t weight, value;
        const uint16_t *constraint;
        if (baseline && (!local || signed32(read32(baseline->record + 4)) >
                                       signed32(read32(local->record + 4)))) {
            MavenReplySummary summary = {0};
            reply = baseline;
            baseline = baseline->next;
            summary.identifier = reply->record[13];
            if (maven_reply_conflicts_with_move(s->conflicts, &summary, move))
                continue;
        } else if (local) {
            if (baseline && !memcmp(local->record + 10, baseline->record + 10, 3))
                baseline = baseline->next;
            if (signed32(read32(local->record + 4)) <= signed32(s->local_cutoff_bits)) {
                local = NULL;
                continue;
            }
            reply = local;
            local = local->next;
        } else
            break;
        weight = read16(reply->record + 56);
        constraint = reply->constraints;
        do {
            uint16_t index = *constraint;
            if (word(weights[index]) < signed32(weight))
                weight = (uint32_t)word(weights[index]);
        } while (*constraint++);
        if (!weight)
            continue;
        constraint = reply->constraints;
        do {
            weights[*constraint] = (uint16_t)(weights[*constraint] - weight);
        } while (*constraint++);
        value = value_reply(s, move, reply);
        last_score = read32(reply->record + 4);
        weighted += value * weight;
    }
    if (weights[0]) {
        uint32_t *cached = &s->fallback_cache[s->value->new_tiles][s->value->used['q']];
        uint32_t leave = (uint32_t)word(s->value->leave[read16(move + 30)]);
        if (*cached == 200000000u)
            *cached = value_reply(s, move, s->fallback_reply) + 300u - leave;
        weighted += (*cached + leave) * (uint32_t)word(weights[0]);
    }
    weighted = (uint32_t)(signed32(weighted) / word(s->total_weight));
    if (signed32(last_score) < signed32(s->minimum_reply_score_bits))
        s->minimum_reply_score_bits = last_score;
    write32(move + 24, weighted);
    maven_insert_ranked_candidate(s->ranking, move, eligible, s);
    return 1;
}
