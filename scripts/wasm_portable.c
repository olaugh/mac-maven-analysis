/* Bounded, serialized adapter for the owned portable engine. Blob0: resource
 * package (43 BE32 offset/length pairs followed by bytes); blob1: dictionary;
 * blob2: position (225 letters,225 flags,16 rack bytes,8 BE score bytes,
 * BE16 row-zero count,one side byte). Callers write only within capacity.
 * Output3:340 move bytes; output4:candidate records (phase,mode,34 move bytes).
 * A failed create discards the old engine. Heap is private to this instance.
 */
#include "portable_engine.h"
#include <string.h>
static uint8_t resources[1048576], dictionary[1200000], position[477];
static uint8_t trace[100000][36];
static unsigned trace_count, overflow;
static union {
  long double alignment;
  uint8_t bytes[4194304];
} heap;
static size_t used;
static MavenPortableEngine *engine;
static MavenCandidateList ranking;
static int used_late;
static uint32_t late_estimate;
static uint8_t clocks[4096 * 4];
static uint8_t game_events[4096 * 8], refill_starts[512 * 4],
    history_wire[65536 + 512 * 4], game_output[314];
static unsigned game_event_count, game_event_index, refill_start_count,
    refill_start_index, wire_length;
static uint32_t game_seed;
/* Simulation config: ten BE32 words:
 * seed,lookahead,flags(exhaustive/late/endgame), sample limit,budget
 * seconds,late calibration,event count,refill count, elapsed count,cancel poll.
 * Output: 460 entry bytes,340 published move bytes, then
 * batches,weight,publications,count,status as BE32. */
static uint8_t simulation_config[40], simulation_output[820],
    simulation_publications[256][348];
static unsigned simulation_publication_count, simulation_event_count,
    simulation_overflow;
static uint32_t simulation_calibration;
static unsigned clock_count, clock_index, clock_error, cancel_poll, poll_index,
    iterations;
static uint32_t be32(const uint8_t *p) {
  return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 |
         p[3];
}
static void *allocate(void *u, size_t n) {
  size_t aligned = (n + 15) & ~(size_t)15;
  void *p;
  (void)u;
  if (aligned < n || sizeof heap.bytes - used < 16 ||
      aligned > sizeof heap.bytes - used - 16)
    return NULL;
  p = heap.bytes + used + 16;
  ((size_t *)(heap.bytes + used))[0] = used;
  used += aligned + 16;
  ((size_t *)((uint8_t *)p - 16))[1] = used;
  return p;
}
static void release(void *u, void *p) {
  (void)u;
  /* Constructor storage and temporary history imports unwind in LIFO order. */
  if (p) {
    size_t *header = (size_t *)((uint8_t *)p - 16);
    if (header[1] == used)
      used = header[0];
  }
}
void *maven_port_buffer(unsigned id) {
  switch (id) {
  case 0:
    return resources;
  case 1:
    return dictionary;
  case 2:
    return position;
  case 3:
    return ranking.moves;
  case 4:
    return trace;
  case 5:
    return clocks;
  case 6:
    return game_events;
  case 7:
    return refill_starts;
  case 8:
    return history_wire;
  case 9:
    return game_output;
  case 10:
    return simulation_config;
  case 11:
    return simulation_output;
  case 12:
    return simulation_publications;
  default:
    return NULL;
  }
}
unsigned maven_port_capacity(unsigned id) {
  switch (id) {
  case 0:
    return sizeof resources;
  case 1:
    return sizeof dictionary;
  case 2:
    return sizeof position;
  case 3:
    return sizeof ranking.moves;
  case 4:
    return sizeof trace;
  case 5:
    return sizeof clocks;
  case 6:
    return sizeof game_events;
  case 7:
    return sizeof refill_starts;
  case 8:
    return sizeof history_wire;
  case 9:
    return sizeof game_output;
  case 10:
    return sizeof simulation_config;
  case 11:
    return sizeof simulation_output;
  case 12:
    return sizeof simulation_publications;
  default:
    return 0;
  }
}
unsigned maven_port_create(unsigned resource_bytes, unsigned dictionary_bytes) {
  MavenTableResources r = {0};
  MavenBlob blobs[43];
  MavenAllocator a = {NULL, allocate, release};
  unsigned i;
  maven_portable_destroy(engine);
  engine = NULL;
  used = 0;
  memset(&ranking, 0, sizeof ranking);
  trace_count = overflow = 0;
  if (resource_bytes > sizeof resources || resource_bytes < 43 * 8 ||
      dictionary_bytes > sizeof dictionary)
    return MAVEN_ENGINE_INVALID;
  for (i = 0; i < 43; i++) {
    uint32_t off = be32(resources + 8 * i), len = be32(resources + 8 * i + 4);
    if (off < 43 * 8 || off > resource_bytes || len > resource_bytes - off)
      return MAVEN_ENGINE_INVALID;
    blobs[i] = (MavenBlob){resources + off, len};
  }
  r.data = blobs[0];
  r.zero = blobs[1];
  r.relocations = blobs[2];
  r.preferences = blobs[3];
  r.patterns = blobs[4];
  r.strings = blobs[5];
  r.scores = blobs[6];
  r.opening = blobs[7];
  for (i = 0; i < 27; i++)
    r.letters[i] = blobs[8 + i];
  for (i = 0; i < 8; i++)
    r.composition[i] = blobs[35 + i];
  return maven_portable_create(&r, (MavenBlob){dictionary, dictionary_bytes},
                               &a, &engine);
}
unsigned maven_port_position(unsigned length) {
  MavenPosition p = {0};
  if (length != sizeof position)
    return MAVEN_ENGINE_INVALID;
  memcpy(p.letters, position, 225);
  memcpy(p.blanks, position + 225, 225);
  memcpy(p.racks, position + 450, 16);
  p.score_bits[0] = be32(position + 466);
  p.score_bits[1] = be32(position + 470);
  p.row_zero_count = (uint16_t)((unsigned)position[474] * 256 + position[475]);
  p.side = position[476];
  return maven_portable_set_position(engine, &p);
}
static void observe(void *u, int phase, int mode, const uint8_t *move) {
  (void)u;
  if (trace_count >= 100000) {
    overflow = 1;
    return;
  }
  trace[trace_count][0] = (uint8_t)phase;
  trace[trace_count][1] = (uint8_t)mode;
  memcpy(trace[trace_count] + 2, move, 34);
  ++trace_count;
}
unsigned maven_port_search(int deduplicate, int offset) {
  unsigned result;
  if (offset < -32768 || offset > 32767)
    return MAVEN_ENGINE_INVALID;
  trace_count = overflow = 0;
  result = maven_portable_heuristic(engine, deduplicate, (int16_t)offset,
                                    &ranking, observe, NULL);
  return overflow ? MAVEN_ENGINE_DIAGNOSTIC : result;
}
unsigned maven_port_late(int force, uint32_t calibration) {
  return maven_portable_late(engine, force, calibration, &ranking, &used_late,
                             &late_estimate);
}
static int32_t elapsed(void *u) {
  uint32_t value;
  (void)u;
  if (clock_index >= clock_count) {
    clock_error = 1;
    return INT32_MAX;
  }
  value = be32(clocks + 4 * clock_index++);
  if (value > INT32_MAX) {
    clock_error = 1;
    return INT32_MAX;
  }
  return (int32_t)value;
}
static int cancelled(void *u) {
  (void)u;
  return clock_error || (cancel_poll && ++poll_index == cancel_poll);
}
/* Replay adapter accepts explicit BE elapsed-second events. Production native
 * callers use callbacks directly; a browser worker can supply equivalent
 * host callbacks when linked through the native API. Stream exhaustion fails
 * without publishing a partial result. */
unsigned maven_port_endgame(uint32_t seed, int32_t budget, unsigned count,
                            unsigned stop_poll) {
  MavenEndgameOptions options = {NULL, elapsed, cancelled, seed, budget};
  MavenCandidateList result;
  unsigned n, status;
  if (count > 4096)
    return MAVEN_ENGINE_INVALID;
  clock_count = count;
  clock_index = clock_error = poll_index = 0;
  cancel_poll = stop_poll;
  status = maven_portable_endgame(engine, &options, &result, &n);
  if (clock_error)
    return MAVEN_ENGINE_INVALID;
  if (status == MAVEN_ENGINE_OK) {
    ranking = result;
    iterations = n;
  }
  return status;
}
unsigned maven_port_count(unsigned kind) {
  switch (kind) {
  case 0:
    return ranking.count;
  case 1:
    return trace_count;
  case 2:
    return ranking.cutoff_bits;
  case 3:
    return (unsigned)used_late;
  case 4:
    return late_estimate;
  case 5:
    return iterations;
  case 6:
    return clock_index;
  case 7:
    return game_seed;
  case 8:
    return game_event_index;
  case 9:
    return refill_start_index;
  case 10:
    return wire_length;
  case 11:
    return (unsigned)maven_portable_history_count(engine);
  case 12:
    return (unsigned)used;
  case 13:
    return simulation_publication_count;
  case 14:
    return simulation_event_count;
  default:
    return 0;
  }
}
static void put32(uint8_t *p, uint32_t v) {
  p[0] = (uint8_t)(v >> 24);
  p[1] = (uint8_t)(v >> 16);
  p[2] = (uint8_t)(v >> 8);
  p[3] = (uint8_t)v;
}
unsigned maven_port_get_position(void) {
  MavenPosition p;
  unsigned result = maven_portable_get_position(engine, &p);
  if (result)
    return result;
  memcpy(position, p.letters, 225);
  memcpy(position + 225, p.blanks, 225);
  memcpy(position + 450, p.racks, 16);
  put32(position + 466, p.score_bits[0]);
  put32(position + 470, p.score_bits[1]);
  position[474] = (uint8_t)(p.row_zero_count >> 8);
  position[475] = (uint8_t)p.row_zero_count;
  position[476] = p.side;
  return result;
}
static int next_game_event(unsigned kind, uint32_t *v) {
  const uint8_t *p;
  if (game_event_index >= game_event_count)
    return 0;
  p = game_events + game_event_index * 8;
  if (be32(p) != kind)
    return 0;
  *v = be32(p + 4);
  ++game_event_index;
  return 1;
}
static int game_tick_input(void *u, uint32_t *v) {
  (void)u;
  return next_game_event(0, v);
}
static int game_random_input(void *u, int16_t *v) {
  uint32_t value;
  (void)u;
  if (!next_game_event(1, &value) || value > 65535)
    return 0;
  *v = (int16_t)value;
  return 1;
}
static int begin_history_refill(void *u, uint32_t *v) {
  (void)u;
  if (refill_start_index >= refill_start_count)
    return 0;
  *v = be32(refill_starts + 4 * refill_start_index++);
  return 1;
}
static void encode_game(const MavenGameResult *r) {
  unsigned i;
  memcpy(game_output, r->move, 34);
  for (i = 0; i < 22; i++)
    put32(game_output + 34 + 4 * i, r->features[i]);
  for (i = 0; i < 44; i++)
    put32(game_output + 122 + 4 * i, r->statistics[i / 22][i % 22]);
  put32(game_output + 298, r->evaluation_bits);
  put32(game_output + 302, r->selected_side);
  put32(game_output + 306, (uint32_t)r->phase);
  put32(game_output + 310, (uint32_t)r->history_records);
}
unsigned maven_port_play(unsigned index, uint32_t seed, uint32_t initial,
                         unsigned events) {
  MavenGameRuntime runtime = {NULL, game_tick_input, game_random_input, seed,
                              initial};
  MavenGameResult result;
  unsigned status;
  if (events > 4096)
    return MAVEN_ENGINE_INVALID;
  game_event_count = events;
  game_event_index = 0;
  status = maven_portable_play_ranked(engine, index, &runtime, &result);
  if (!status) {
    encode_game(&result);
    game_seed = runtime.private_seed;
  }
  return status;
}
unsigned maven_port_load(unsigned length, uint32_t seed, unsigned events,
                         unsigned starts) {
  MavenHistoryRuntime runtime = {
      {NULL, game_tick_input, game_random_input, seed, 0},
      begin_history_refill};
  unsigned status;
  if (length > sizeof history_wire || events > 4096 || starts > 512)
    return MAVEN_ENGINE_INVALID;
  game_event_count = events;
  game_event_index = 0;
  refill_start_count = starts;
  refill_start_index = 0;
  status = maven_portable_load(engine, history_wire, length, &runtime);
  if (!status)
    game_seed = runtime.random.private_seed;
  return status;
}
unsigned maven_port_history_select(unsigned index, uint32_t seed,
                                   unsigned events, unsigned starts) {
  MavenHistoryRuntime runtime = {
      {NULL, game_tick_input, game_random_input, seed, 0},
      begin_history_refill};
  unsigned status;
  if (events > 4096 || starts > 512)
    return MAVEN_ENGINE_INVALID;
  game_event_count = events;
  game_event_index = 0;
  refill_start_count = starts;
  refill_start_index = 0;
  status = maven_portable_history_select(engine, index, &runtime);
  if (!status)
    game_seed = runtime.random.private_seed;
  return status;
}
unsigned maven_port_save(void) {
  size_t length;
  unsigned result =
      maven_portable_save(engine, history_wire, sizeof history_wire, &length);
  if (!result)
    wire_length = (unsigned)length;
  return result;
}

static uint32_t simulation_cpu(void *u) {
  (void)u;
  return simulation_calibration;
}
static int simulation_runtime_failed(void *u) {
  (void)u;
  return clock_error || simulation_overflow;
}
static int simulation_stop(void *u) {
  return simulation_overflow || cancelled(u);
}
static void simulation_published(void *u, const uint8_t *moves,
                                 unsigned count) {
  uint8_t *p;
  (void)u;
  if (count > 10 || simulation_publication_count >= 256) {
    simulation_overflow = 1;
    return;
  }
  p = simulation_publications[simulation_publication_count++];
  memset(p, 0, 348);
  put32(p, count);
  put32(p + 4, simulation_event_count);
  memcpy(p + 8, moves, count * 34);
}
static void simulation_observed(void *u, int kind, unsigned candidate,
                                unsigned reply) {
  (void)u;
  (void)kind;
  (void)candidate;
  (void)reply;
  simulation_event_count++;
}
unsigned maven_port_simulate(void) {
  MavenSimulationOptions options = {0};
  MavenSimulationResult result;
  MavenHistoryRuntime runtime = {
      {NULL, game_tick_input, game_random_input, 0, 0}, begin_history_refill};
  uint32_t config[10];
  unsigned i, status;
  for (i = 0; i < 10; i++)
    config[i] = be32(simulation_config + 4 * i);
  if (config[1] > 16383 || config[2] > 7 || config[4] > INT32_MAX ||
      config[6] > 4096 || config[7] > 512 || config[8] > 4096)
    return MAVEN_ENGINE_INVALID;
  runtime.random.private_seed = config[0];
  options.lookahead = (int)config[1];
  options.exhaustive = config[2] & 1;
  options.late_enabled = (config[2] >> 1) & 1;
  options.endgame_enabled = (config[2] >> 2) & 1;
  options.sample_limit = config[3];
  options.endgame_budget_seconds = (int32_t)config[4];
  simulation_calibration = config[5];
  options.late_calibration = simulation_cpu;
  options.elapsed_seconds = elapsed;
  options.cancel_requested = simulation_stop;
  options.runtime_failed = simulation_runtime_failed;
  options.publish = simulation_published;
  options.event = simulation_observed;
  game_event_count = config[6];
  refill_start_count = config[7];
  clock_count = config[8];
  cancel_poll = config[9];
  game_event_index = refill_start_index = clock_index = clock_error =
      poll_index = 0;
  simulation_publication_count = simulation_event_count = simulation_overflow =
      0;
  status = maven_portable_simulate(engine, &options, &runtime, &result);
  if (clock_error)
    return MAVEN_ENGINE_EXTERNAL;
  if (simulation_overflow)
    return MAVEN_ENGINE_CAPACITY;
  if (status == MAVEN_ENGINE_OK || status == MAVEN_ENGINE_CANCELLED) {
    memcpy(simulation_output, result.entries, 460);
    memcpy(simulation_output + 460, result.published, 340);
    put32(simulation_output + 800, result.batches);
    put32(simulation_output + 804, result.total_weight);
    put32(simulation_output + 808, result.publications);
    put32(simulation_output + 812, result.count);
    put32(simulation_output + 816, result.status);
    game_seed = runtime.random.private_seed;
    if (result.publications) {
      memcpy(ranking.moves, result.published, 340);
      ranking.count = (uint16_t)result.count;
      ranking.cutoff_bits = maven_move_rank_bits(ranking.moves[9]);
    }
  }
  return status;
}
