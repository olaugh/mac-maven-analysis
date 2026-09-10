#include "simulation_session.h"
#include "candidate_ranking.h"
#include "opponent_samples.h"
#include "rack_counts.h"
#include "remaining_tiles.h"
#include <string.h>
static int rack_terminated(const uint8_t *rack) {
    unsigned i;for(i=0;i<8;i++)if(!rack[i])return 1;return 0;
}
static void checkpoint(MavenSimulationSession *s, const char *phase) {
    if (s->checkpoint) s->checkpoint(s->user, phase);
}
static void publish(MavenSimulationSession *s) {
    maven_rank_sampled_candidates(s->rollout->entries, s->rollout->count, s->ranked[0]);
    if (s->publish) s->publish(s->user, s->ranked[0], s->rollout->count);
}
int maven_begin_simulation_session(MavenSimulationSession *s) {
    MavenRolloutSearch *r;
    if (!s || s->status == MAVEN_SIMULATION_RUNNING || !(r=s->rollout) ||
        !r->application || !s->leaves || !s->distribution || !r->entries ||
        !r->count || r->count>64 || r->reply_plies<0 || r->selected_side!=0 ||
        !r->racks[0] || !r->racks[1] || !r->select || !r->refill ||
        !rack_terminated(r->racks[0]) || !rack_terminated(r->racks[1])) return 0;
    maven_save_simulation_position(&s->saved,r->application->placement.board,
        r->application->placement.values,r->racks[0],r->racks[1],r->selected_side);
    s->batches=s->total_weight=0;
    s->status=MAVEN_SIMULATION_RUNNING;
    checkpoint(s,"started");
    return 1;
}
MavenSimulationStatus maven_finish_simulation_session(MavenSimulationSession *s,
                                                      MavenSimulationStatus reason) {
    MavenRolloutSearch *r;
    MavenApplyState *a;
    if (!s) return MAVEN_SIMULATION_ERROR;
    if (s->status!=MAVEN_SIMULATION_RUNNING) return s->status;
    r=s->rollout; a=r->application;
    if (reason==MAVEN_SIMULATION_IDLE || reason==MAVEN_SIMULATION_RUNNING)
        return s->status;
    checkpoint(s,"before_restore");
    maven_restore_simulation_position(&s->saved,a->placement.board,a->placement.values,
        r->racks[0],r->racks[1],&r->selected_side);
    checkpoint(s,"board_racks_restored");
    maven_count_rack(a->placement.counts,a->alphabet,r->racks[r->selected_side]);
    maven_rack_from_counts(s->sorted_rack,a->placement.counts,a->alphabet);
    maven_count_unseen_tiles(s->unseen,s->distribution,a->placement.board,
        a->placement.values,a->placement.counts,a->alphabet);
    s->leaves->sorted_rack=s->sorted_rack;
    s->leaves->unseen_counts=s->unseen;
    maven_prepare_leave_table(s->leaves);
    checkpoint(s,"leave_rebuilt");
    s->status=reason;
    return reason;
}
MavenSimulationStatus maven_step_simulation_session(MavenSimulationSession *s) {
    MavenRolloutSearch *r;
    MavenApplyState *a;
    if (!s) return MAVEN_SIMULATION_ERROR;
    if (s->status!=MAVEN_SIMULATION_RUNNING) return s->status;
    r=s->rollout; a=r->application;
    if (!s->stack_ticks || !s->random.private_random || !s->random.toolbox_random ||
        !s->random.read_ticks) return maven_finish_simulation_session(s,MAVEN_SIMULATION_ERROR);
    maven_draw_random_opponent(s->sample,r->racks[1],r->racks[0],s->bag,
        s->distribution,a->placement.board,a->placement.values,a->alphabet,
        s->stack_ticks(s->clock_user),&s->random);
    publish(s);
    if (!maven_run_rollout_batch_checked(r,s->sample,1))
        return maven_finish_simulation_session(s,MAVEN_SIMULATION_CANCELLED);
    ++s->batches; ++s->total_weight;
    if (maven_simulation_sample_limit_reached(r->entries,s->limit_bits,0))
        return maven_finish_simulation_session(s,MAVEN_SIMULATION_LIMIT);
    return s->status;
}
static int16_t exhaustive_batch(void *user,const uint8_t *rack,uint32_t weight) {
    MavenSimulationSession *s=user;
    publish(s);
    if (!maven_run_rollout_batch_checked(s->rollout,rack,weight)) {
        maven_finish_simulation_session(s,MAVEN_SIMULATION_CANCELLED);
        return 1;
    }
    ++s->batches; s->total_weight+=weight;
    return 0;
}
MavenSimulationStatus maven_run_exhaustive_session(MavenSimulationSession *s) {
    MavenRolloutSearch *r;
    MavenApplyState *a;
    int16_t total;
    if (!s) return MAVEN_SIMULATION_ERROR;
    if (s->status!=MAVEN_SIMULATION_RUNNING) return s->status;
    r=s->rollout; a=r->application;
    if (!s->choose) return maven_finish_simulation_session(s,MAVEN_SIMULATION_ERROR);
    maven_count_rack(a->placement.counts,a->alphabet,r->racks[0]);
    total=maven_count_unseen_tiles(s->unseen,s->distribution,a->placement.board,
        a->placement.values,a->placement.counts,a->alphabet);
    if (total<7 || total>=18) return maven_finish_simulation_session(s,MAVEN_SIMULATION_ERROR);
    maven_enumerate_opponent_samples(s->unseen,a->alphabet,s->choose,exhaustive_batch,s);
    if (s->status!=MAVEN_SIMULATION_RUNNING) return s->status;
    publish(s);
    return maven_finish_simulation_session(s,MAVEN_SIMULATION_EXHAUSTED);
}
