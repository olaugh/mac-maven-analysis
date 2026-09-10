/* WebAssembly bridge for the playable Maven application.
 *
 * Unlike the research adapter (scripts/wasm_portable.c), this bridge runs
 * with live host callbacks instead of recorded event streams: the host
 * supplies a tick counter, a per-search elapsed-seconds clock and a
 * cooperative cancellation flag; Toolbox Random is reproduced here. All
 * buffers are fixed and bounded; integers in serialized buffers are big
 * endian. One engine instance lives for the lifetime of the module, as one
 * Maven application instance did on the Mac. */
#include "portable_engine_app.h"
#include "search_policy.h"
#include <string.h>

/* Host imports (module "env"). */
__attribute__((import_module("env"), import_name("host_ticks"))) uint32_t host_ticks(void);
__attribute__((import_module("env"), import_name("host_elapsed_seconds"))) int32_t host_elapsed_seconds(void);
__attribute__((import_module("env"), import_name("host_cancel_requested"))) int32_t host_cancel_requested(void);
__attribute__((import_module("env"), import_name("host_publish"))) void host_publish(const uint8_t *moves, unsigned count);
__attribute__((import_module("env"), import_name("host_progress"))) void host_progress(int kind, unsigned a, unsigned b);
__attribute__((import_module("env"), import_name("host_search_started"))) void host_search_started(int kind);

#define RESOURCE_BYTES 1048576
#define DICTIONARY_BYTES 4194304
#define TEXT_BYTES 262144
static uint8_t resources[RESOURCE_BYTES], dictionary[DICTIONARY_BYTES];
static uint8_t position[477], move_input[64], history_wire[65536 + 512 * 4];
static uint8_t statistics_out[176], play_out[314], simulation_out[820];
static uint8_t text[TEXT_BYTES], unseen_out[128];
static union {
  long double alignment;
  uint8_t bytes[6 * 1048576];
} heap;
static size_t used;
static MavenPortableEngine *engine;
static MavenCandidateList ranking;
static unsigned last_kind, iterations, wire_length, text_length, list_count;
static uint32_t private_seed = 0x2545f491u, toolbox_seed = 1, cutoff_bits;
static uint32_t late_estimate;
static int used_late, last_status;

static uint32_t be32(const uint8_t *p) {
  return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3];
}
static void put32(uint8_t *p, uint32_t v) {
  p[0] = (uint8_t)(v >> 24);
  p[1] = (uint8_t)(v >> 16);
  p[2] = (uint8_t)(v >> 8);
  p[3] = (uint8_t)v;
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
  if (p) {
    size_t *header = (size_t *)((uint8_t *)p - 16);
    if (header[1] == used)
      used = header[0];
  }
}

/* Classic Mac OS Random(): Park-Miller minimal standard on randSeed,
 * returning the low word, with -32768 mapped to zero. */
static int16_t toolbox_random(void) {
  uint32_t seed = toolbox_seed ? toolbox_seed : 1;
  uint32_t lo = seed % 127773, hi = seed / 127773;
  int32_t t = (int32_t)(16807 * lo) - (int32_t)(2836 * hi);
  if (t <= 0)
    t += 0x7fffffff;
  toolbox_seed = (uint32_t)t;
  {
    uint16_t low = (uint16_t)toolbox_seed;
    return low == 0x8000 ? 0 : (int16_t)low;
  }
}
static uint32_t last_ticks;
static int runtime_ticks(void *u, uint32_t *v) {
  uint32_t t = host_ticks();
  (void)u;
  /* The original spins until TickCount changes; a fast host must not spend
   * thousands of RNG events waiting for a 60 Hz clock, so ticks are forced
   * strictly monotonic per read. */
  if (t <= last_ticks)
    t = last_ticks + 1;
  last_ticks = t;
  *v = t;
  return 1;
}
static int runtime_random(void *u, int16_t *v) {
  (void)u;
  *v = toolbox_random();
  return 1;
}
static MavenGameRuntime runtime(void) {
  MavenGameRuntime r = {NULL, runtime_ticks, runtime_random, private_seed, 0};
  return r;
}

void *app_buffer(unsigned id) {
  switch (id) {
  case 0: return resources;
  case 1: return dictionary;
  case 2: return position;
  case 3: return ranking.moves;
  case 4: return history_wire;
  case 5: return statistics_out;
  case 6: return text;
  case 7: return play_out;
  case 8: return move_input;
  case 9: return simulation_out;
  case 10: return unseen_out;
  default: return NULL;
  }
}
unsigned app_capacity(unsigned id) {
  switch (id) {
  case 0: return sizeof resources;
  case 1: return sizeof dictionary;
  case 2: return sizeof position;
  case 3: return sizeof ranking.moves;
  case 4: return sizeof history_wire;
  case 5: return sizeof statistics_out;
  case 6: return sizeof text;
  case 7: return sizeof play_out;
  case 8: return sizeof move_input;
  case 9: return sizeof simulation_out;
  case 10: return sizeof unseen_out;
  default: return 0;
  }
}

unsigned app_create(unsigned resource_bytes, unsigned dictionary_bytes) {
  MavenTableResources r = {0};
  MavenBlob blobs[43];
  MavenAllocator a = {NULL, allocate, release};
  unsigned i, status;
  maven_portable_destroy(engine);
  engine = NULL;
  used = 0;
  memset(&ranking, 0, sizeof ranking);
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
  status = maven_portable_create(&r, (MavenBlob){dictionary, dictionary_bytes},
                                 &a, &engine);
  if (status == MAVEN_ENGINE_OK)
    maven_app_capture_lexicon(engine);
  return status;
}
unsigned app_set_lexicon(unsigned mode) { return maven_app_set_lexicon(engine, mode); }
void app_set_seeds(uint32_t private_value, uint32_t toolbox_value) {
  if (private_value && private_value <= 0x7fffffffu)
    private_seed = private_value;
  toolbox_seed = toolbox_value ? toolbox_value : 1;
}
uint32_t app_private_seed(void) { return private_seed; }
uint32_t app_toolbox_seed(void) { return toolbox_seed; }

unsigned app_set_position(void) {
  MavenPosition p = {0};
  memcpy(p.letters, position, 225);
  memcpy(p.blanks, position + 225, 225);
  memcpy(p.racks, position + 450, 16);
  p.score_bits[0] = be32(position + 466);
  p.score_bits[1] = be32(position + 470);
  p.row_zero_count = (uint16_t)((unsigned)position[474] * 256 + position[475]);
  p.side = position[476];
  return maven_portable_set_position(engine, &p);
}
unsigned app_get_position(void) {
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
unsigned app_deal(unsigned first_side) {
  MavenGameRuntime r = runtime();
  unsigned status = maven_app_deal(engine, first_side, &r);
  if (status == MAVEN_ENGINE_OK)
    private_seed = r.private_seed;
  return status;
}

static void observe(void *u, int phase, int mode, const uint8_t *move) {
  (void)u;
  (void)phase;
  (void)mode;
  (void)move;
}
static int32_t elapsed(void *u) {
  (void)u;
  return host_elapsed_seconds();
}
static int cancelled(void *u) {
  (void)u;
  return host_cancel_requested() != 0;
}
static int board_empty(void) {
  unsigned i;
  if (app_get_position())
    return 0;
  for (i = 0; i < 225; i++)
    if (position[i])
      return 0;
  return 1;
}
unsigned app_search_heuristic(int deduplicate, int offset) {
  host_search_started(0);
  last_status = maven_portable_heuristic(engine, deduplicate, (int16_t)offset,
                                         &ranking, observe, NULL);
  last_kind = 0;
  cutoff_bits = ranking.cutoff_bits;
  return last_status;
}
unsigned app_search_late(int force) {
  host_search_started(2);
  last_status = maven_portable_late(engine, force, 0, &ranking, &used_late,
                                    &late_estimate);
  last_kind = 2;
  return last_status;
}
unsigned app_search_endgame(int32_t budget) {
  MavenEndgameOptions options = {NULL, elapsed, cancelled, private_seed, budget};
  MavenCandidateList result;
  unsigned n, status;
  host_search_started(1);
  status = maven_portable_endgame(engine, &options, &result, &n);
  if (status == MAVEN_ENGINE_OK) {
    ranking = result;
    iterations = n;
    /* Advance the private stream so consecutive endgame searches do not
     * reuse one hash seed. */
    private_seed = ((private_seed >> 1) +
                    ((((private_seed >> 4) ^ private_seed) & 1) ? 0x40000000u : 0)) |
                   1;
  }
  last_kind = 1;
  last_status = status;
  return status;
}
/* Kibitz: choose the search exactly as CODE3 does from the unseen total and
 * the analyzer flags, using CODE44's opening word deduplication. */
unsigned app_kibitz(int endgame_enabled, int late_enabled, int32_t budget) {
  int total = maven_app_unseen(engine, unseen_out);
  MavenSearchKind kind;
  if (total < 0)
    return MAVEN_ENGINE_NO_POSITION;
  kind = maven_choose_search_kind((int16_t)total, endgame_enabled, late_enabled);
  if (kind == MAVEN_SEARCH_ENDGAME)
    return app_search_endgame(budget);
  if (kind == MAVEN_SEARCH_LATE)
    return app_search_late(1);
  return app_search_heuristic(board_empty(), 0);
}

int app_level = 0;      /* menu index 0..17 */
int16_t app_rating = 2100;  /* player rating for the leave bias */
void app_set_level(int level_index, int rating) {
  if (level_index >= 0 && level_index < 18) app_level = level_index;
  if (rating > 0 && rating < 4000) app_rating = (int16_t)rating;
}
void app_level_reset(void) { maven_portable_level_reset(engine); }
void app_set_level_counter(unsigned n) { maven_portable_level_set(engine, n); }
unsigned app_level_counter(void) { return maven_portable_level_counter(engine); }
/* Computer move honoring the selected level. Level 0 is the full Kibitz
 * dispatch; higher levels run the nerfed heuristic. */
unsigned app_move(int endgame_enabled, int late_enabled, int32_t budget) {
  if (app_level == 0)
    return app_kibitz(endgame_enabled, late_enabled, budget);
  host_search_started(0);
  last_status = maven_portable_heuristic_leveled(engine, app_level, app_rating,
                                                 &ranking, observe, NULL);
  last_kind = 0;
  cutoff_bits = ranking.cutoff_bits;
  return last_status;
}
unsigned app_count(unsigned what) {
  switch (what) {
  case 0: return ranking.count;
  case 1: return last_kind;
  case 2: return cutoff_bits;
  case 3: return (unsigned)used_late;
  case 4: return late_estimate;
  case 5: return iterations;
  case 6: return wire_length;
  case 7: return (unsigned)maven_portable_history_count(engine);
  case 8: return (unsigned)used;
  case 9: return text_length;
  case 10: return list_count;
  case 11: return (unsigned)last_status;
  default: return 0;
  }
}

static void encode_result(const MavenGameResult *r) {
  unsigned i;
  memcpy(play_out, r->move, 34);
  for (i = 0; i < 22; i++)
    put32(play_out + 34 + 4 * i, r->features[i]);
  for (i = 0; i < 44; i++)
    put32(play_out + 122 + 4 * i, r->statistics[i / 22][i % 22]);
  put32(play_out + 298, r->evaluation_bits);
  put32(play_out + 302, r->selected_side);
  put32(play_out + 306, (uint32_t)r->phase);
  put32(play_out + 310, (uint32_t)r->history_records);
}
unsigned app_play_ranked(unsigned index) {
  MavenGameRuntime r = runtime();
  MavenGameResult result;
  unsigned status = maven_portable_play_ranked(engine, index, &r, &result);
  if (status == MAVEN_ENGINE_OK) {
    encode_result(&result);
    private_seed = r.private_seed;
  }
  return status;
}
/* move_input: word[16], new_tile[16], blank[16], row, column, vertical. */
unsigned app_play_move(void) {
  MavenAppMove m;
  MavenGameRuntime r = runtime();
  MavenGameResult result;
  unsigned status;
  memcpy(m.word, move_input, 16);
  memcpy(m.new_tile, move_input + 16, 16);
  memcpy(m.blank, move_input + 32, 16);
  m.row = move_input[48];
  m.column = move_input[49];
  m.vertical = move_input[50];
  status = maven_app_play_move(engine, &m, &r, &result);
  if (status == MAVEN_ENGINE_OK) {
    encode_result(&result);
    private_seed = r.private_seed;
  }
  return status;
}
/* move_input: NUL-terminated tiles to exchange (empty passes). */
unsigned app_play_exchange(void) {
  MavenGameRuntime r = runtime();
  MavenGameResult result;
  unsigned status;
  move_input[8] = 0;
  status = maven_app_play_exchange(engine, move_input, &r, &result);
  if (status == MAVEN_ENGINE_OK) {
    encode_result(&result);
    private_seed = r.private_seed;
  }
  return status;
}

unsigned app_save(void) {
  size_t length;
  unsigned status = maven_portable_save(engine, history_wire, sizeof history_wire, &length);
  if (status == MAVEN_ENGINE_OK)
    wire_length = (unsigned)length;
  return status;
}
static MavenHistoryRuntime history_runtime(void) {
  MavenHistoryRuntime h = {{NULL, runtime_ticks, runtime_random, 0, 0}, NULL};
  h.random.private_seed = private_seed;
  return h;
}
unsigned app_load(unsigned length) {
  MavenHistoryRuntime h = history_runtime();
  unsigned status;
  if (length > sizeof history_wire)
    return MAVEN_ENGINE_INVALID;
  status = maven_portable_load(engine, history_wire, length, &h);
  if (status == MAVEN_ENGINE_OK)
    private_seed = h.random.private_seed;
  return status;
}
unsigned app_history_select(unsigned index) {
  MavenHistoryRuntime h = history_runtime();
  unsigned status = maven_portable_history_select(engine, index, &h);
  if (status == MAVEN_ENGINE_OK)
    private_seed = h.random.private_seed;
  return status;
}
/* Copy history record descriptors as text lines "tag length hexpayload"
 * into the text buffer so the host can render Show History. */
unsigned app_history_records(void) {
  unsigned status = app_save();
  return status;
}

void app_statistics(void) {
  uint32_t s[2][22];
  unsigned i;
  maven_app_statistics(engine, s);
  for (i = 0; i < 44; i++)
    put32(statistics_out + 4 * i, s[i / 22][i % 22]);
}
int app_unseen(void) { return maven_app_unseen(engine, unseen_out); }
/* text buffer holds a NUL-terminated lowercase word. */
int app_word_acceptable(void) {
  text[TEXT_BYTES - 1] = 0;
  return maven_app_word_acceptable(engine, text);
}
static void list_emit(void *u, const uint8_t *word) {
  size_t n = strlen((const char *)word);
  (void)u;
  if (text_length + n + 1 >= TEXT_BYTES)
    return;
  memcpy(text + text_length, word, n);
  text_length += (unsigned)n;
  text[text_length++] = '\n';
  ++list_count;
}
/* text buffer: four NUL-terminated strings rack, on_board, prefix, suffix. */
int app_word_list(int bingos, int minimum, int maximum) {
  uint8_t rack[128], on_board[128], prefix[128], suffix[128];
  const uint8_t *p = text;
  uint8_t *fields[4] = {rack, on_board, prefix, suffix};
  unsigned f;
  int result;
  for (f = 0; f < 4; f++) {
    unsigned n = 0;
    while (*p && n < 127)
      fields[f][n++] = *p++;
    fields[f][n] = 0;
    if (*p)
      return -1;
    ++p;
  }
  text_length = 0;
  list_count = 0;
  result = maven_app_word_list(engine, rack, on_board, prefix, suffix, bingos,
                               minimum, maximum, list_emit, NULL);
  text[text_length] = 0;
  return result;
}
void app_letter_values(void) {
  const uint16_t *v = maven_app_letter_values(engine);
  const uint8_t *d = maven_app_distribution(engine);
  unsigned i;
  for (i = 0; i < 128; i++) {
    text[i] = (uint8_t)(v ? v[i] : 0);
    text[128 + i] = d ? d[i] : 0;
  }
}

/* Simulation with live callbacks. Configuration: lookahead, flags (bit0
 * exhaustive, bit1 late, bit2 endgame), sample limit, endgame budget. */
static uint32_t simulation_calibration_value(void *u) {
  (void)u;
  return 1;
}
static void simulation_started(void *u) {
  (void)u;
  host_search_started(1);
}
static void published(void *u, const uint8_t *moves, unsigned count) {
  (void)u;
  memcpy(ranking.moves, moves, count * 34);
  ranking.count = (uint16_t)count;
  host_publish(moves, count);
}
static void event(void *u, int kind, unsigned candidate, unsigned reply) {
  (void)u;
  host_progress(kind, candidate, reply);
}
unsigned app_simulate(unsigned lookahead, unsigned flags, uint32_t sample_limit,
                      int32_t budget) {
  MavenSimulationOptions options = {0};
  MavenSimulationResult result;
  MavenHistoryRuntime h = history_runtime();
  unsigned status;
  options.lookahead = (int)lookahead;
  options.exhaustive = flags & 1;
  options.late_enabled = (flags >> 1) & 1;
  options.endgame_enabled = (flags >> 2) & 1;
  options.sample_limit = sample_limit;
  options.endgame_budget_seconds = budget;
  options.late_calibration = simulation_calibration_value;
  options.endgame_started = simulation_started;
  options.elapsed_seconds = elapsed;
  options.cancel_requested = cancelled;
  options.publish = published;
  options.event = event;
  status = maven_portable_simulate(engine, &options, &h, &result);
  if (status == MAVEN_ENGINE_OK || status == MAVEN_ENGINE_CANCELLED) {
    memcpy(simulation_out, result.entries, 460);
    memcpy(simulation_out + 460, result.published, 340);
    put32(simulation_out + 800, result.batches);
    put32(simulation_out + 804, result.total_weight);
    put32(simulation_out + 808, result.publications);
    put32(simulation_out + 812, result.count);
    put32(simulation_out + 816, result.status);
    private_seed = h.random.private_seed;
    if (result.publications) {
      memcpy(ranking.moves, result.published, 340);
      ranking.count = (uint16_t)result.count;
      ranking.cutoff_bits = maven_move_rank_bits(ranking.moves[9]);
    }
  }
  return status;
}
