#include "simulation_search.h"
#include "candidate_ranking.h"
#include "opponent_samples.h"
#include "rack_counts.h"
#include "remaining_tiles.h"

#include <string.h>

unsigned maven_seed_simulation_candidates(uint8_t entries[64 * 46], const uint8_t *moves,
                                          unsigned count) {
    unsigned i;
    if (count > 64)
        count = 64;
    memset(entries, 0, 64 * 46);
    for (i = 0; i < count; ++i) {
        uint8_t *entry = entries + 46 * i;
        uint32_t seed = maven_move_rank_bits(moves + 34 * i);
        memcpy(entry, moves + 34 * i, 34);
        entry[34] = (uint8_t)(seed >> 24);
        entry[35] = (uint8_t)(seed >> 16);
        entry[36] = (uint8_t)(seed >> 8);
        entry[37] = (uint8_t)seed;
    }
    return count;
}
int16_t maven_simulation_reply_plies(int16_t lookahead) {
    uint16_t result = (uint16_t)((uint16_t)(lookahead > 0 ? lookahead : 1) << 1);
    return result < 32768 ? (int16_t)result : (int16_t)((int32_t)result - 65536);
}

static void publish(MavenExhaustiveSimulation *s) {
    maven_rank_sampled_candidates(s->rollout->entries, s->rollout->count, s->ranked[0]);
    if (s->publish)
        s->publish(s->user, s->ranked[0], s->rollout->count);
}
static int16_t simulate(void *user, const uint8_t *rack, uint32_t weight) {
    MavenExhaustiveSimulation *s = user;
    publish(s);
    if (!maven_run_rollout_batch_checked(s->rollout, rack, weight))
        return 1;
    ++s->batches;
    s->total_weight += weight;
    return 0;
}
int maven_simulate_all_opponent_racks(MavenExhaustiveSimulation *s) {
    uint8_t counts[128] = {0}, unseen[128] = {0};
    MavenRolloutSearch *r = s->rollout;
    MavenApplyState *app = r->application;
    int16_t total;
    if (!r->count || r->count > 64 || r->reply_plies < 0)
        return 0;
    maven_count_rack(counts, app->alphabet, r->racks[0]);
    total = maven_count_unseen_tiles(unseen, s->distribution, app->placement.board,
                                     app->placement.values, counts, app->alphabet);
    if (total < 7 || total >= 18)
        return 0;
    s->batches = s->total_weight = 0;
    if (maven_enumerate_opponent_samples(unseen, app->alphabet, s->choose, simulate, s))
        return 0;
    publish(s);
    return 1;
}
