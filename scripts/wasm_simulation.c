/* Reuse the existing freestanding engine's table/state staging interface. */
#include "random_opponent.h"
#include "search_dispatch.h"
#include "simulation_search.h"
#include "simulation_restore.h"
#include "simulation_session.h"
#include "wasm_engine.c"
static MavenSearchDispatch dispatch;
static MavenLateSearch late_search;
static uint16_t late_tables[648];
static uint8_t late_priority[28], late_q[16], late_blank[16], late_exchange_q[16];
static int16_t late_leave_offset;
#include "rack_counts.h"
#include "rack_refill.h"
#include "remaining_tiles.h"
static MavenRolloutSearch rollout;
static MavenSimulationSnapshot saved_position;
void maven_simulation_save_position(void){maven_save_simulation_position(&saved_position,board,values,rack,opponent,rollout.selected_side);}
void maven_simulation_restore_position(void){maven_restore_simulation_position(&saved_position,board,values,rack,opponent,&rollout.selected_side);}
static MavenExhaustiveSimulation simulation;
static MavenSimulationSession session;
static uint8_t session_records[3][6000];
static uint32_t session_phase_count,session_record_size;
/* Bounded publication observer for preserved session fixtures. */
static uint8_t publication_records[64][2184];
static unsigned publication_count;
static MavenEndgameGeneration end_generation;
static MavenEndgameTree end_tree;
static MavenEndgameNode end_nodes[8192];
static MavenEndgameSearch end_search;
static uint32_t end_bits[32], end_hash[16], end_calls[1024][7], end_clocks[16384][2];
static uint8_t end_rows[32];
static unsigned end_call_count, end_clock_count, end_call_index, end_clock_index;
static int32_t end_elapsed(void *u) {
    uint32_t bits;
    int32_t result;
    (void)u;
    if (end_call_index >= end_call_count || end_clock_index >= end_clock_count)
        __builtin_trap();
    bits = end_clocks[end_clock_index][0] - end_calls[end_call_index][4] + 30;
    result =
        (int32_t)(bits <= INT32_MAX ? (int64_t)bits : (int64_t)bits - INT64_C(4294967296)) / 60;
    if ((uint32_t)result != end_clocks[end_clock_index++][1])
        __builtin_trap();
    return result;
}

static uint8_t simulation_entries[64 * 46], event_records[2048][5000];
static uint16_t binomial_choose[18][8];
/* External observations, explicitly staged: kinds0=private return check,
 * 1=Toolbox Random,2=TickCount. The private stream itself is computed. */
static uint32_t random_inputs[100000][2], refill_ticks[4096];
static uint32_t random_count, random_index, refill_count, refill_index, private_seed;
static uint32_t event_count, event_size, single_weight, cancel_after_events;
static int cancelled(void *u){(void)u;return cancel_after_events && event_count>=cancel_after_events;}
static uint8_t single_sample[8], draw_bag[128];
static int exhaustive_mode = 1;
static uint32_t read_input(unsigned kind) {
    uint32_t value;
    if (random_index >= random_count || random_inputs[random_index][0] != kind)
        __builtin_trap();
    value = random_inputs[random_index++][1];
    if (kind == 0 && maven_private_random_next(&private_seed) != value)
        __builtin_trap();
    return value;
}
static uint32_t next_private(void *u) {
    (void)u;
    return read_input(0);
}
static int16_t next_toolbox(void *u) {
    uint16_t v;
    (void)u;
    v = (uint16_t)read_input(1);
    return v < 32768 ? (int16_t)v : (int16_t)((int32_t)v - 65536);
}
static uint32_t next_ticks(void *u) {
    (void)u;
    return read_input(2);
}
static void select_reply(void *u, int side, uint8_t out[34]) {
    uint8_t selected_counts[128] = {0}, unseen[128] = {0};
    int16_t total;
    int use_end;
    (void)u;
    maven_count_rack(selected_counts, application.alphabet, rollout.racks[side]);
    total = maven_count_unseen_tiles(unseen, distribution, board, values, selected_counts,
                                     application.alphabet);
    use_end = maven_choose_search_kind(total, dispatch.endgame_enabled, dispatch.late_enabled) ==
              MAVEN_SEARCH_ENDGAME;
    if (use_end) {
        uint32_t *call;
        if (end_call_index >= end_call_count)
            __builtin_trap();
        call = end_calls[end_call_index];
        if (call[0] != event_count || call[1] != (unsigned)side || call[5] != end_clock_index)
            __builtin_trap();
        dispatch.endgame_budget_seconds = (int32_t)call[2];
        end_search.reserve_control = (int16_t)call[3];
    }
    dispatch.heuristic = &search;
    memcpy(dispatch.selected_move, rollout.selected_move, 34);
    if (!maven_select_best_move(&dispatch, rollout.racks[side], rollout.racks[1 - side]))
        __builtin_trap();
    memcpy(out, dispatch.selected_move, 34);
    if (use_end) {
        uint32_t *call = end_calls[end_call_index++];
        if (end_clock_index != call[5] + call[6])
            __builtin_trap();
    }
}
static void refill_reply(void *u, int side) {
    uint8_t bag[128];
    uint32_t length;
    MavenRefillOps ops = {0, next_private, next_toolbox, next_ticks};
    (void)u;
    if (refill_index >= refill_count)
        __builtin_trap();
    length =
        maven_collect_remaining_tiles(bag, distribution, board, values, rack, opponent, alphabet);
    maven_refill_rack_from_bag(rollout.racks[side], bag, length, board,
                               refill_ticks[refill_index++], &ops);
}
static void put32(uint8_t **p, uint32_t v) {
    *(*p)++ = (uint8_t)(v >> 24);
    *(*p)++ = (uint8_t)(v >> 16);
    *(*p)++ = (uint8_t)(v >> 8);
    *(*p)++ = (uint8_t)v;
}
static void putbytes(uint8_t **p, const void *source, size_t length) {
    memcpy(*p, source, length);
    *p += length;
}
static void session_checkpoint(void *u, const char *phase) {
    uint8_t *p;
    const uint16_t *arrays[] = {leaves.values, leaves.tile_points,
        (const uint16_t *)leaves.canonical_masks, &leaves.occurrence_masks[0][0]};
    const unsigned lengths[] = {128,128,128,1024};
    unsigned i,k;
    (void)u;
    if (!strcmp(phase,"started")) return;
    if(session_phase_count>=3) __builtin_trap();
    p=session_records[session_phase_count++];
    putbytes(&p,board,544);
    for(i=0;i<544;i++){*p++=(uint8_t)(values[i]>>8);*p++=(uint8_t)values[i];}
    putbytes(&p,rack,8);putbytes(&p,opponent,8);putbytes(&p,counts,128);putbytes(&p,undo,33);
    for(k=0;k<4;k++)for(i=0;i<lengths[k];i++){*p++=(uint8_t)(arrays[k][i]>>8);*p++=(uint8_t)arrays[k][i];}
    for(i=0;i<128;i++)put32(&p,leaves.mask_generations[i]);
    put32(&p,leaves.generation);
    session_record_size=(uint32_t)(p-session_records[session_phase_count-1]);
}
static void session_publish(void *u,const uint8_t *moves,unsigned count) {
    uint8_t *p;
    (void)u;
    if(publication_count>=64||count>64)__builtin_trap();
    p=publication_records[publication_count++];
    put32(&p,count);put32(&p,event_count);
    putbytes(&p,moves,count*34);
}
static void observe_simulation(void *u, MavenRolloutEvent kind, unsigned candidate_index,
                               unsigned reply) {
    uint8_t *p;
    unsigned i;
    (void)u;
    if (event_count >= 2048)
        __builtin_trap();
    p = event_records[event_count++];
    put32(&p, kind);
    put32(&p, candidate_index);
    put32(&p, reply);
    put32(&p, (uint32_t)rollout.selected_side);
    put32(&p, (uint32_t)application.row_zero_count);
    put32(&p, (uint32_t)application.new_tiles);
    for (i = 0; i < 2; ++i)
        put32(&p, (uint32_t)application.recorded_row[i]);
    for (i = 0; i < 2; ++i)
        put32(&p, (uint32_t)application.recorded_column[i]);
    putbytes(&p, board, 544);
    for (i = 0; i < 544; ++i) {
        *p++ = (uint8_t)(values[i] >> 8);
        *p++ = (uint8_t)values[i];
    }
    putbytes(&p, rack, 8);
    putbytes(&p, opponent, 8);
    putbytes(&p, counts, 128);
    putbytes(&p, undo, 33);
    putbytes(&p, rollout.selected_move, 34);
    putbytes(&p, simulation_entries, 46 * rollout.count);
    event_size = (uint32_t)(p - event_records[event_count - 1]);
    if (event_size > 5000)
        __builtin_trap();
}
void *maven_simulation_buffer(unsigned id) {
    switch (id) {
    case 0:
        return simulation_entries;
    case 1:
        return binomial_choose;
    case 2:
        return random_inputs;
    case 3:
        return refill_ticks;
    case 4:
        return rollout.selected_move;
    case 5:
        return simulation.ranked;
    case 6:
        return end_bits;
    case 7:
        return end_hash;
    case 8:
        return end_rows;
    case 9:
        return end_calls;
    case 10:
        return end_clocks;
    case 11:
        return single_sample;
    case 12:
        return late_tables;
    case 13:
        return late_priority;
    case 14:
        return late_q;
    case 15:
        return late_blank;
    case 16:
        return late_exchange_q;
    case 17:
        return draw_bag;
    case 18:
        return session_records;
    case 19:return publication_records;
    default:
        __builtin_trap();
    }
}
void maven_simulation_set(unsigned id, uint32_t value) {
    switch (id) {
    case 0:
        rollout.count = (uint16_t)value;
        break;
    case 1:
        rollout.reply_plies = (int16_t)value;
        break;
    case 2:
        rollout.selected_side = (int)value;
        break;
    case 3:
        private_seed = value;
        break;
    case 4:
        random_count = value;
        break;
    case 5:
        refill_count = value;
        break;
    case 6:
        dispatch.endgame_enabled = (int)value;
        break;
    case 7:
        dispatch.late_enabled = (int)value;
        break;
    case 8:
        end_call_count = value;
        break;
    case 9:
        end_clock_count = value;
        break;
    case 10:
        exhaustive_mode = (int)value;
        break;
    case 11:
        single_weight = value;
        break;
    case 12:
        late_leave_offset = (int16_t)value;
        break;
    case 13:
        cancel_after_events=value;
        break;
    default:
        __builtin_trap();
    }
}
uint32_t maven_simulation_get(unsigned id) {
    switch (id) {
    case 0:
        return event_count;
    case 1:
        return event_size;
    case 2:
        return random_index;
    case 3:
        return refill_index;
    case 4:
        return private_seed;
    case 5:
        return simulation.batches;
    case 6:
        return simulation.total_weight;
    case 7:
        return end_call_index;
    case 8:
        return end_clock_index;
    case 9:
        return (uint32_t)rollout.selected_side;
    case 10:return session_phase_count;
    case 11:return session_record_size;
    case 12:return session.status;
    case 13:return publication_count;
    default:
        __builtin_trap();
    }
}
void *maven_simulation_event(unsigned index) {
    if (index >= event_count)
        __builtin_trap();
    return event_records[index];
}
static uint32_t session_stack_ticks(void *u) {
    (void)u;
    if(refill_index>=refill_count)__builtin_trap();
    return refill_ticks[refill_index++];
}
int maven_simulation_run(void) {
    int i;
    if (random_count > 100000 || refill_count > 4096)
        __builtin_trap();
    end_call_index = end_clock_index = 0;
    if (end_call_count > 1024 || end_clock_count > 16384)
        __builtin_trap();
    random_index = refill_index = event_count = trace_count = 0;
    evaluation.premium.penalties = penalties;
    for (i = 0; i < patterns.count; ++i)
        patterns.entries[i].accumulator = pattern_stamps[i];
    search.candidate = 0;
    rollout.application = &application;
    rollout.racks[0] = rack;
    rollout.racks[1] = opponent;
    rollout.entries = simulation_entries;
    rollout.select = select_reply;
    rollout.refill = refill_reply;
    rollout.observe = observe_simulation;
    rollout.cancelled = cancelled;
    end_generation.application = &application;
    end_generation.sections = sections;
    end_generation.bit_masks = end_bits;
    end_generation.row_flags = end_rows;
    end_generation.bingo_bonus = 5000;
    end_tree.nodes = end_nodes;
    end_tree.capacity = 8192;
    end_tree.diagnostic = diagnostic;
    end_search.leaf.generation = &end_generation;
    end_search.leaf.tree = &end_tree;
    end_search.leaf.hash_table = end_hash;
    end_search.letter_values = letter_values;
    end_search.elapsed_seconds = end_elapsed;
    dispatch.endgame = &end_search;
    late_search.application = &application;
    late_search.leaves = &leaves;
    late_search.patterns = evaluation.patterns;
    late_search.sections = sections;
    late_search.bit_masks = end_bits;
    late_search.choose = (const uint16_t(*)[8])late_tables;
    late_search.priority_order = late_priority;
    late_search.q_query = late_q;
    late_search.blank_query = late_blank;
    late_search.exchange_q_string = late_exchange_q;
    late_search.row_flags = end_rows;
    late_search.bingo_bonus = 5000;
    late_search.leave_offset = late_leave_offset;
    dispatch.late = &late_search;
    memcpy(late_search.value.normal_bag, late_tables + 586, 20);
    memcpy(late_search.value.held_q_bag, late_tables + 596, 20);
    memcpy(late_search.value.reply_q_bag, late_tables + 606, 20);
    memcpy(late_search.value.normal_empty_bag, late_tables + 266, 128);
    memcpy(late_search.value.held_q_no_u, late_tables + 330, 128);
    memcpy(late_search.value.held_q_with_u, late_tables + 458, 128);
    memcpy(late_search.value.blank_adjustment, late_tables + 138, 128);
    memcpy(late_search.value.opponent_held_q, late_tables + 394, 128);
    late_search.value.normal_before_matrix = late_tables[(0x65a8 - 0x6316) / 2];
    late_search.value.with_u_before_matrix = late_tables[(0x65a8 - 0x6216) / 2];
    if (dispatch.late_enabled || dispatch.endgame_enabled)
        search.row_flags = end_rows;
    simulation.rollout = &rollout;
    simulation.distribution = distribution;
    simulation.choose = binomial_choose;
    if (exhaustive_mode == 2) {
        MavenRefillOps ops = {0, next_private, next_toolbox, next_ticks};
        if (refill_index >= refill_count)
            __builtin_trap();
        maven_draw_random_opponent(single_sample, opponent, rack, draw_bag, distribution, board,
                                   values, alphabet, refill_ticks[refill_index++], &ops);
    }
    if (exhaustive_mode == 3 || exhaustive_mode == 4) {
        memset(&session,0,sizeof session);session_phase_count=0;publication_count=0;
        session.rollout=&rollout;session.leaves=&leaves;session.distribution=distribution;
        session.choose=binomial_choose;session.checkpoint=session_checkpoint;
        session.publish=session_publish;
        if(exhaustive_mode==4){
            session.random=(MavenRefillOps){0,next_private,next_toolbox,next_ticks};
            session.stack_ticks=session_stack_ticks;session.limit_bits=single_weight;
            memcpy(session.sample,single_sample,8);
        }
        if(!maven_begin_simulation_session(&session))return 0;
        if(exhaustive_mode==3){
            if(maven_run_exhaustive_session(&session)!=MAVEN_SIMULATION_EXHAUSTED)return 0;
        }else{
            if(maven_step_simulation_session(&session)!=(cancel_after_events?MAVEN_SIMULATION_CANCELLED:MAVEN_SIMULATION_LIMIT))return 0;
            memcpy(single_sample,session.sample,8);memcpy(draw_bag,session.bag,128);
        }
        simulation.batches=session.batches;simulation.total_weight=session.total_weight;
        memcpy(simulation.ranked,session.ranked,sizeof simulation.ranked);
    } else if (exhaustive_mode == 1) {
        if (!maven_simulate_all_opponent_racks(&simulation))
            return 0;
    } else {
        maven_run_rollout_batch(&rollout, single_sample, single_weight);
        maven_rank_sampled_candidates(simulation_entries, rollout.count, simulation.ranked[0]);
        simulation.batches = 1;
        simulation.total_weight = single_weight;
    }
    if (random_index != random_count || refill_index != refill_count ||
        end_call_index != end_call_count || end_clock_index != end_clock_count)
        __builtin_trap();
    for (i = 0; i < patterns.count; ++i)
        pattern_stamps[i] = patterns.entries[i].accumulator;
    return 1;
}
