#include "portable_engine.h"
#include "board_state.h"
#include "dictionary_validate.h"
#include "endgame_search.h"
#include "game_turn.h"
#include "hash_initializer.h"
#include "heuristic_search.h"
#include "history_playback.h"
#include "history_store.h"
#include "late_search.h"
#include "late_search_budget.h"
#include "pattern_cache.h"
#include "rack_composition.h"
#include "rack_counts.h"
#include "remaining_tiles.h"
#include "search_dispatch.h"
#include "simulation_session.h"
#include <string.h>
struct MavenPortableEngine {
  MavenAllocator allocator;
  MavenEngineTables tables;
  uint8_t *dictionary;
  MavenDictionarySection sections[3];
  MavenPatternEntry entries[MAVEN_MAX_PATTERNS];
  MavenPatternCache cache;
  MavenPosition position;
  int ready, diagnostics;
  uint8_t board[544], counts[128], undo[33], racks[2][8];
  uint16_t values[544];
  MavenApplyState application;
  MavenRackBalanceCache balance;
  MavenMoveEvaluation evaluation;
  MavenLeaveTable leaves;
  MavenCandidateList ranking;
  MavenCandidateList last_ranking;
  int has_ranking, finished, branch_pending;
  uint16_t level_counter; /* Persistent CODE13 acceptance-filter counter. */
  uint32_t statistics[2][22];
  MavenHistoryStore history;
  MavenHistoryRecord history_records[512];
  uint8_t history_bytes[65536];
  int16_t collector_ids[MAVEN_MAX_PATTERNS + 40],
      collector_weights[MAVEN_MAX_PATTERNS + 40];
  MavenLateSearch late;
  uint32_t bit_masks[32];
  uint16_t late_tables[648], late_workload[6][9];
  MavenEndgameSearch endgame;
  MavenEndgameGeneration generation;
  MavenEndgameTree tree;
  MavenEndgameNode nodes[8192];
  uint32_t hash[16];
  MavenRolloutSearch rollout;
  MavenSimulationSession simulation;
  uint8_t simulation_entries[64 * 46];
  void (*candidate)(void *, int, int, const uint8_t *);
  void *candidate_user;
};
static void diagnostic(void *u) {
  MavenPortableEngine *e = u;
  e->diagnostics = 1;
}
static void *pattern_allocate(void *u, size_t bytes) {
  MavenPortableEngine *e = u;
  return bytes <= sizeof e->entries ? e->entries : NULL;
}
static uint32_t composition(void *u, int16_t v, int16_t c, int16_t pv,
                            int16_t pc, int16_t n) {
  MavenPortableEngine *e = u;
  if (n < 0 || n > 7) {
    diagnostic(e);
    return 0;
  }
  return maven_rack_composition(v, c, pv, pc, n,
                                e->tables.composition_scores[n]);
}
static void observe(void *u, int phase, const uint8_t *move) {
  MavenPortableEngine *e = u;
  if (e->candidate)
    e->candidate(e->candidate_user, phase,
                 move[32] ? maven_count_new_move_tiles(move, e->board) : 0,
                 move);
}
static uint16_t read16(const uint8_t *p) {
  return (uint16_t)((unsigned)p[0] * 256 + p[1]);
}
static uint32_t read32(const uint8_t *p) {
  return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 |
         p[3];
}
MavenEngineResult maven_portable_create(const MavenTableResources *r,
                                        MavenBlob dictionary,
                                        const MavenAllocator *allocator,
                                        MavenPortableEngine **output) {
  MavenPortableEngine *e;
  MavenDictionarySection sections[3];
  if (!output)
    return MAVEN_ENGINE_INVALID;
  *output = NULL;
  if (!allocator || !allocator->allocate || !allocator->release || !r ||
      !maven_validate_dictionary(dictionary.data, dictionary.size, sections))
    return MAVEN_ENGINE_INVALID;
  e = allocator->allocate(allocator->user, sizeof *e);
  if (!e)
    return MAVEN_ENGINE_ALLOCATION;
  memset(e, 0, sizeof *e);
  e->allocator = *allocator;
  if (maven_initialize_engine_tables(&e->tables, r) != MAVEN_TABLES_OK) {
    maven_portable_destroy(e);
    return MAVEN_ENGINE_INVALID;
  }
  e->dictionary = allocator->allocate(allocator->user, dictionary.size);
  if (!e->dictionary) {
    maven_portable_destroy(e);
    return MAVEN_ENGINE_ALLOCATION;
  }
  memcpy(e->dictionary, dictionary.data, dictionary.size);
  maven_validate_dictionary(e->dictionary, dictionary.size, e->sections);
  maven_prepare_pattern_cache(&e->cache, e->tables.patterns,
                              e->tables.pattern_count, e->tables.strings,
                              pattern_allocate, diagnostic, e);
  if (e->diagnostics) {
    maven_portable_destroy(e);
    return MAVEN_ENGINE_INVALID;
  }
  *output = e;
  return MAVEN_ENGINE_OK;
}
void maven_portable_destroy(MavenPortableEngine *e) {
  MavenAllocator allocator;
  if (!e)
    return;
  allocator = e->allocator;
  if (e->dictionary)
    allocator.release(allocator.user, e->dictionary);
  allocator.release(allocator.user, e);
}
MavenEngineResult maven_portable_set_position(MavenPortableEngine *e,
                                              const MavenPosition *p) {
  unsigned used[128] = {0}, held[128] = {0}, i, s, occupied = 0, total = 0;
  if (!e || !p || p->side > 1 || p->row_zero_count > 32767)
    return MAVEN_ENGINE_INVALID;
  for (i = 0; i < 225; i++) {
    uint8_t c = p->letters[i];
    if (p->blanks[i] > 1 || (!c && p->blanks[i]) || (c && (c < 'a' || c > 'z')))
      return MAVEN_ENGINE_INVALID;
    if (c) {
      ++used[p->blanks[i] ? '?' : c];
      ++occupied;
    }
  }
  if (occupied && !p->letters[112])
    return MAVEN_ENGINE_INVALID;
  for (s = 0; s < 2; s++) {
    unsigned n = 0;
    while (n < 8 && p->racks[s][n]) {
      uint8_t c = p->racks[s][n++];
      if (c != '?' && (c < 'a' || c > 'z'))
        return MAVEN_ENGINE_INVALID;
      ++used[c];
      if (s == p->side)
        ++held[c];
    }
    if (!n || n == 8)
      return MAVEN_ENGINE_INVALID;
  }
  for (i = 0; i < 128; i++) {
    if (used[i] > e->tables.distribution[i])
      return MAVEN_ENGINE_INVALID;
    total += e->tables.distribution[i];
  }
  {
    unsigned own = 0;
    for (i = 0; i < 128; i++)
      own += held[i];
    if (occupied + own >= total)
      return MAVEN_ENGINE_INVALID;
  }
  e->position = *p;
  e->ready = 1;
  e->has_ranking = e->finished = e->branch_pending = 0;
  memset(e->statistics, 0, sizeof e->statistics);
  e->history = (MavenHistoryStore){
      e->history_records, 0, 512, e->history_bytes, 0, sizeof e->history_bytes};
  return MAVEN_ENGINE_OK;
}
MavenEngineResult maven_portable_get_position(const MavenPortableEngine *e,
                                              MavenPosition *p) {
  if (!e || !p)
    return MAVEN_ENGINE_INVALID;
  if (!e->ready)
    return MAVEN_ENGINE_NO_POSITION;
  *p = e->position;
  return MAVEN_ENGINE_OK;
}
static void prepare_search(MavenPortableEngine *e) {
  MavenEngineTables *t;
  MavenApplyState *a;
  MavenMoveEvaluation *v;
  MavenLeaveTable *l;
  unsigned i;
  t = &e->tables;
  a = &e->application;
  v = &e->evaluation;
  l = &e->leaves;
  memset(e->board, 0, sizeof e->board);
  memset(e->values, 0, sizeof e->values);
  memset(e->counts, 0, sizeof e->counts);
  memset(e->undo, 0, sizeof e->undo);
  memset(a, 0, sizeof *a);
  memset(v, 0, sizeof *v);
  memset(l, 0, sizeof *l);
  memset(&e->balance, 0, sizeof e->balance);
  memset(&e->ranking, 0, sizeof e->ranking);
  for (i = 0; i < (unsigned)e->cache.count; i++)
    e->entries[i].accumulator = 0;
  for (i = 0; i < 225; i++) {
    unsigned row = i / 15 + 1, col = i % 15 + 1, index = row * 17 + col,
             cross = (col + 15) * 17 + row;
    uint8_t c = e->position.letters[i];
    e->board[index] = e->board[cross] = c;
    e->values[index] = e->values[cross] =
        !c || e->position.blanks[i] ? 0 : t->letter_values[c];
  }
  memcpy(e->racks[0], e->position.racks[e->position.side], 8);
  memcpy(e->racks[1], e->position.racks[1 - e->position.side], 8);
  a->placement = (MavenLetterPlacement){
      e->board, e->values,  e->counts, t->letter_values, t->word_multipliers,
      e->undo,  diagnostic, e};
  a->letter_multipliers = t->letter_multipliers;
  a->letter_class = t->classes;
  a->alphabet = t->alphabet;
  a->row_zero_count = (int16_t)e->position.row_zero_count;
  e->balance.evaluate_composition = composition;
  e->balance.user = e;
  e->balance.diagnostic = diagnostic;
  v->application = a;
  v->rack = e->racks[0];
  v->distribution = t->distribution;
  v->vowel_characters = t->vowels;
  v->premium = (MavenPremiumExposureInput){
      e->board,   t->word_multipliers, t->letter_multipliers,
      t->classes, t->penalties,        diagnostic,
      e};
  v->balance = &e->balance;
  v->lookup_entries = e->entries;
  v->lookup_count = e->cache.count;
  v->patterns = (MavenPatternMatchInput){
      t->patterns,      t->strings, t->scores,        e->board,   e->values,
      t->letter_values, e->counts,  t->pattern_count, diagnostic, e};
  v->opening_scores = t->opening;
  v->small_pool_scores = t->small_pool;
  v->q_with_unseen_u = t->q_with_u;
  v->q_without_held_u = t->q_without_u;
  v->unseen_q_query = t->q_query;
  v->held_u_query = t->u_query;
  v->letter_scores = t->letter_scores;
  l->alphabet = t->alphabet;
  l->vowel_characters = t->vowels;
  l->distribution = t->distribution;
  l->letter_values = t->letter_values;
  l->letter_scores = t->letter_scores;
  l->q_with_unseen_u = t->q_with_u;
  l->q_without_held_u = t->q_without_u;
  l->held_u_query = t->u_query;
  l->patterns = e->entries;
  l->pattern_count = e->cache.count;
  l->score_records = t->scores;
  l->balance = &e->balance;
}
MavenEngineResult
maven_portable_heuristic(MavenPortableEngine *e, int deduplicate,
                         int16_t offset, MavenCandidateList *output,
                         void (*candidate)(void *, int, int, const uint8_t *),
                         void *user) {
  MavenHeuristicSearch search = {0};
  if (!e || !output || (deduplicate != 0 && deduplicate != 1))
    return MAVEN_ENGINE_INVALID;
  if (!e->ready)
    return MAVEN_ENGINE_NO_POSITION;
  if (e->finished)
    return MAVEN_ENGINE_UNSUPPORTED;
  prepare_search(e);
  search.sections = e->sections;
  search.evaluation = &e->evaluation;
  search.leaves = &e->leaves;
  search.result = &e->ranking;
  search.opponent_rack = e->racks[1];
  search.leave_offset = offset;
  search.word_deduplication = deduplicate;
  search.candidate = observe;
  search.user = e;
  search.row_flags = e->tables.globals + MAVEN_GLOBAL_BYTES - 0x6d2;
  e->candidate = candidate;
  e->candidate_user = user;
  e->diagnostics = 0;
  maven_search_heuristic_moves_shared(&search, e->tables.globals +
                                                   MAVEN_GLOBAL_BYTES - 0x6f2);
  e->candidate = NULL;
  e->candidate_user = NULL;
  if (e->diagnostics)
    return MAVEN_ENGINE_DIAGNOSTIC;
  *output = e->ranking;
  e->last_ranking = *output;
  e->has_ranking = 1;
  return MAVEN_ENGINE_OK;
}
void maven_portable_level_reset(MavenPortableEngine *e) {
  if (e)
    e->level_counter = 0;
}
void maven_portable_level_set(MavenPortableEngine *e, unsigned counter) {
  if (e)
    e->level_counter = (uint16_t)(counter & 0xff);
}
unsigned maven_portable_level_counter(const MavenPortableEngine *e) {
  return e ? e->level_counter : 0;
}
MavenEngineResult maven_portable_heuristic_leveled(
    MavenPortableEngine *e, int level_index, int16_t player_rating,
    MavenCandidateList *output,
    void (*candidate)(void *, int phase, int mode, const uint8_t move[34]),
    void *user) {
  MavenHeuristicSearch search = {0};
  MavenLevelFilter filter;
  if (!e || !output || level_index < 0 || level_index >= MAVEN_LEVEL_COUNT)
    return MAVEN_ENGINE_INVALID;
  if (!e->ready)
    return MAVEN_ENGINE_NO_POSITION;
  if (e->finished)
    return MAVEN_ENGINE_UNSUPPORTED;
  prepare_search(e);
  maven_level_filter_init(&filter, level_index, e->level_counter);
  search.sections = e->sections;
  search.evaluation = &e->evaluation;
  search.leaves = &e->leaves;
  search.result = &e->ranking;
  search.opponent_rack = e->racks[1];
  search.leave_offset = maven_level_leave_offset(level_index, player_rating);
  search.word_deduplication = 0;
  search.candidate = observe;
  search.user = e;
  search.row_flags = e->tables.globals + MAVEN_GLOBAL_BYTES - 0x6d2;
  search.level = &filter;
  e->candidate = candidate;
  e->candidate_user = user;
  e->diagnostics = 0;
  maven_search_heuristic_moves_shared(&search, e->tables.globals +
                                                   MAVEN_GLOBAL_BYTES - 0x6f2);
  e->candidate = NULL;
  e->candidate_user = NULL;
  e->level_counter = filter.counter;
  if (e->diagnostics)
    return MAVEN_ENGINE_DIAGNOSTIC;
  *output = e->ranking;
  e->last_ranking = *output;
  e->has_ranking = 1;
  return MAVEN_ENGINE_OK;
}
static int configure_late(MavenPortableEngine *e, int force) {
  MavenLateSearch *s;
  const uint8_t *g = e->tables.globals + MAVEN_GLOBAL_BYTES;
  uint32_t priority, query;
  unsigned i;
  priority = read32(g - 0x8da);
  query = read32(g - 0x6c44);
  if (priority > MAVEN_GLOBAL_BYTES - 28 || query > MAVEN_GLOBAL_BYTES - 2 ||
      memcmp(e->tables.globals + priority, "?stronleaiudgmpbchfywvkxjzq", 28) ||
      memcmp(e->tables.globals + query, "q", 2) || memcmp(g - 0x97c, "?", 2))
    return 0;
  for (i = 0; i < 32; i++)
    e->bit_masks[i] = read32(g - 0x662a + 4 * i);
  for (i = 0; i < 648; i++)
    e->late_tables[i] = read16(g - 0x65a8 + 2 * i);
  s = &e->late;
  memset(s, 0, sizeof *s);
  s->application = &e->application;
  s->leaves = &e->leaves;
  s->patterns = e->evaluation.patterns;
  s->sections = e->sections;
  s->bit_masks = e->bit_masks;
  s->choose = (const uint16_t (*)[8])e->late_tables;
  s->priority_order = e->tables.globals + priority;
  s->q_query = e->tables.globals + query;
  s->blank_query = g - 0x97c;
  s->bingo_bonus = 5000;
  s->own_rack = e->racks[0];
  s->force = force;
  s->exchange_q_string = g - 0x710;
  s->row_flags = g - 0x6d2;
#define COPY_WORDS(member, off, n)                                             \
  memcpy(s->value.member, e->late_tables + (0x65a8 - (off)) / 2, (n) * 2)
  COPY_WORDS(normal_bag, 0x6114, 10);
  COPY_WORDS(held_q_bag, 0x6100, 10);
  COPY_WORDS(reply_q_bag, 0x60ec, 10);
  COPY_WORDS(normal_empty_bag, 0x6394, 64);
  COPY_WORDS(held_q_no_u, 0x6314, 64);
  COPY_WORDS(held_q_with_u, 0x6214, 64);
  COPY_WORDS(blank_adjustment, 0x6494, 64);
  COPY_WORDS(opponent_held_q, 0x6294, 64);
#undef COPY_WORDS
  s->value.normal_before_matrix = e->late_tables[(0x65a8 - 0x6316) / 2];
  s->value.with_u_before_matrix = e->late_tables[(0x65a8 - 0x6216) / 2];
  return 1;
}
MavenEngineResult maven_portable_late(MavenPortableEngine *e, int force,
                                      uint32_t calibration,
                                      MavenCandidateList *output,
                                      int *used_late, uint32_t *estimate) {
  MavenLateSearch *s;
  const uint8_t *g;
  uint8_t unseen[128] = {0};
  int total, decision;
  uint32_t calculated = 0;
  unsigned i;
  if (!e || !output || !used_late || !estimate || (force != 0 && force != 1))
    return MAVEN_ENGINE_INVALID;
  if (!e->ready)
    return MAVEN_ENGINE_NO_POSITION;
  if (e->finished)
    return MAVEN_ENGINE_UNSUPPORTED;
  prepare_search(e);
  g = e->tables.globals + MAVEN_GLOBAL_BYTES;
  e->diagnostics = 0;
  maven_count_rack(e->counts, e->tables.alphabet, e->racks[0]);
  total = maven_count_unseen_tiles(unseen, e->tables.distribution, e->board,
                                   e->values, e->counts, e->tables.alphabet);
  if (total < 8 || total > 16)
    return MAVEN_ENGINE_UNSUPPORTED;
  for (i = 0; i < 54; i++)
    e->late_workload[i / 9][i % 9] = read16(g - 0x89a + 2 * i);
  decision = maven_late_search_decision(e->late_workload, e->counts['?'],
                                        unseen['?'], (unsigned)total,
                                        calibration, force, &calculated);
  if (decision < 0)
    return MAVEN_ENGINE_INVALID;
  if (decision) {
    MavenEngineResult r = maven_portable_heuristic(e, 0, 0, output, NULL, NULL);
    if (r == MAVEN_ENGINE_OK) {
      *used_late = 0;
      *estimate = calculated;
    }
    return r;
  }
  if (!configure_late(e, force))
    return MAVEN_ENGINE_INVALID;
  s = &e->late;
  if (!maven_search_late_game_shared(s, e->tables.globals + MAVEN_GLOBAL_BYTES -
                                            0x6f2) ||
      e->diagnostics)
    return MAVEN_ENGINE_DIAGNOSTIC;
  *output = s->ranking;
  e->last_ranking = *output;
  e->has_ranking = 1;
  *used_late = 1;
  *estimate = calculated;
  return MAVEN_ENGINE_OK;
}
static void configure_endgame(MavenPortableEngine *e) {
  MavenEndgameSearch *s;
  MavenEndgameGeneration *g;
  s = &e->endgame;
  g = &e->generation;
  memset(s, 0, sizeof *s);
  memset(g, 0, sizeof *g);
  memset(&e->tree, 0, sizeof e->tree);
  g->application = &e->application;
  g->sections = e->sections;
  g->bit_masks = e->bit_masks;
  g->row_flags = e->tables.globals + MAVEN_GLOBAL_BYTES - 0x6d2;
  g->bingo_bonus = 5000;
  e->tree.nodes = e->nodes;
  e->tree.capacity = 8192;
  e->tree.diagnostic = diagnostic;
  e->tree.user = e;
  s->leaf.generation = g;
  s->leaf.tree = &e->tree;
  s->leaf.hash_table = e->hash;
  s->letter_values = e->tables.letter_values;
  s->own_rack = e->racks[0];
  s->other_rack = e->racks[1];
}
MavenEngineResult maven_portable_endgame(MavenPortableEngine *e,
                                         const MavenEndgameOptions *options,
                                         MavenCandidateList *output,
                                         unsigned *iterations) {
  MavenEndgameSearch *s;
  MavenEndgameGeneration *g;
  uint8_t unseen[128] = {0};
  int total;
  uint32_t seed, hash[16] = {0};
  unsigned i;
  if (!e || !options || !output || !iterations || !options->elapsed_seconds ||
      !options->private_seed || options->private_seed > 0x7fffffffu ||
      options->budget_seconds < 0)
    return MAVEN_ENGINE_INVALID;
  if (!e->ready)
    return MAVEN_ENGINE_NO_POSITION;
  if (e->finished)
    return MAVEN_ENGINE_UNSUPPORTED;
  prepare_search(e);
  e->diagnostics = 0;
  maven_count_rack(e->counts, e->tables.alphabet, e->racks[0]);
  total = maven_count_unseen_tiles(unseen, e->tables.distribution, e->board,
                                   e->values, e->counts, e->tables.alphabet);
  if (total < 1 || total > 7 ||
      (unsigned)total != strlen((const char *)e->racks[1]) || !e->board[144])
    return MAVEN_ENGINE_UNSUPPORTED;
  for (i = 0; i < 32; i++)
    e->bit_masks[i] =
        read32(e->tables.globals + MAVEN_GLOBAL_BYTES - 0x662a + 4 * i);
  seed = options->private_seed;
  if (!maven_initialize_hash_table(hash, &seed))
    return MAVEN_ENGINE_INVALID;
  configure_endgame(e);
  s = &e->endgame;
  g = &e->generation;
  s->leaf.hash_table = hash;
  s->user = options->user;
  s->elapsed_seconds = options->elapsed_seconds;
  s->cancel_requested = options->cancel_requested;
  s->budget_seconds = options->budget_seconds;
  maven_search_endgame_shared(s,
                              e->tables.globals + MAVEN_GLOBAL_BYTES - 0x6f2);
  if (s->was_cancelled)
    return MAVEN_ENGINE_CANCELLED;
  if (e->diagnostics)
    return MAVEN_ENGINE_DIAGNOSTIC;
  *output = g->ranking;
  e->last_ranking = *output;
  e->has_ranking = 1;
  *iterations = s->iterations;
  return MAVEN_ENGINE_OK;
}

typedef struct {
  MavenGameRuntime *runtime;
  uint32_t seed, last_ticks;
  unsigned events;
  int failed;
} GameInputs;
static uint32_t game_random(void *user) {
  GameInputs *in = user;
  if (++in->events > 4096)
    in->failed = 1;
  return maven_private_random_next(&in->seed);
}
static int16_t game_toolbox(void *user) {
  GameInputs *in = user;
  int16_t value = 0;
  if (++in->events > 4096)
    in->failed = 1;
  if (!in->failed && !in->runtime->toolbox_random(in->runtime->user, &value))
    in->failed = 1;
  return value;
}
static uint32_t game_ticks(void *user) {
  GameInputs *in = user;
  uint32_t value = in->last_ticks + 1;
  if (++in->events > 4096)
    in->failed = 1;
  if (!in->failed && !in->runtime->read_ticks(in->runtime->user, &value))
    in->failed = 1;
  if (in->failed)
    value = in->last_ticks + 1;
  in->last_ticks = value;
  return value;
}
static int game_append(void *user, int tag, const uint8_t *payload,
                       size_t length) {
  MavenPortableEngine *e = user;
  return maven_history_store_append(&e->history, (int8_t)tag, payload,
                                    length) == MAVEN_HISTORY_OK;
}
static void prepare_game(MavenPortableEngine *e) {
  prepare_search(e);
  memcpy(e->racks, e->position.racks, sizeof e->racks);
  e->evaluation.rack = e->racks[e->position.side];
  maven_count_rack(e->counts, e->tables.alphabet, e->evaluation.rack);
  e->diagnostics = 0;
}
static MavenEngineResult start_history(MavenPortableEngine *e) {
  if (e->history.count && !e->branch_pending)
    return MAVEN_ENGINE_OK;
  if (maven_history_store_snapshot(&e->history, e->board, e->values,
                                   e->racks[0], e->racks[1],
                                   e->position.score_bits) != MAVEN_HISTORY_OK)
    return MAVEN_ENGINE_CAPACITY;
  e->branch_pending = 0;
  return MAVEN_ENGINE_OK;
}
MavenEngineResult maven_portable_play_ranked(MavenPortableEngine *e,
                                             unsigned index,
                                             MavenGameRuntime *runtime,
                                             MavenGameResult *result) {
  MavenGameTurn game = {0};
  MavenAppliedMove workspace = {{0}, 0};
  MavenDisplayMoveScore display_score;
  MavenGameResult output = {0};
  GameInputs inputs;
  uint8_t display[289], move[34];
  size_t old_count, old_used;
  unsigned i, side;
  int old_branch;
  MavenEngineResult error = MAVEN_ENGINE_OK;
  if (!e || !runtime || !result || !runtime->read_ticks ||
      !runtime->toolbox_random || !runtime->private_seed ||
      runtime->private_seed > 0x7fffffff)
    return MAVEN_ENGINE_INVALID;
  if (!e->ready)
    return MAVEN_ENGINE_NO_POSITION;
  if (e->finished)
    return MAVEN_ENGINE_UNSUPPORTED;
  if (!e->has_ranking || index >= e->last_ranking.count)
    return MAVEN_ENGINE_INVALID;
  if (e->history.record_capacity - e->history.count <
          (e->history.count && !e->branch_pending ? 3u : 5u) ||
      e->history.byte_capacity - e->history.used <
          (e->history.count && !e->branch_pending ? 88u : 388u))
    return MAVEN_ENGINE_CAPACITY;
  memcpy(move, e->last_ranking.moves[index], 34);
  side = e->position.side;
  if (side == 0) {
    size_t n = strlen((const char *)move);
    memset(move + n, 0, 16 - n);
    memset(move + 20, 0, 12);
  }
  old_count = e->history.count;
  old_used = e->history.used;
  old_branch = e->branch_pending;
  prepare_game(e);
  /* Build the human staged display using the same blank assignment as the
   * selected engine move. The subsequent real commit starts from the original
   * position; no display bytes or scorer state are supplied by the caller. */
  if (side == 0) {
    maven_apply_move_with_details(move, e->racks[0], &e->application, 5000,
                                  &workspace);
    if (e->diagnostics)
      return MAVEN_ENGINE_DIAGNOSTIC;
    for (i = 0; i < 289; i++)
      display[i] = e->board[i] && e->values[i]
                       ? (uint8_t)(e->board[i] - 'a' + 'A')
                       : e->board[i];
    prepare_game(e);
    memset(&workspace, 0, sizeof workspace);
    display_score = (MavenDisplayMoveScore){&e->application, display,
                                            e->tables.classes, e->racks[0]};
    game.display_score = &display_score;
  }
  if (start_history(e) != MAVEN_ENGINE_OK)
    return MAVEN_ENGINE_CAPACITY;
  inputs = (GameInputs){runtime, runtime->private_seed,
                        runtime->initial_stack_ticks, 0, 0};
  game.evaluation = &e->evaluation;
  game.racks[0] = e->racks[0];
  game.racks[1] = e->racks[1];
  memcpy(game.totals, e->position.score_bits, sizeof game.totals);
  memcpy(game.statistics, e->statistics, sizeof game.statistics);
  game.selected_side = side;
  game.display_order = e->tables.display_order;
  game.refill =
      (MavenRefillOps){&inputs, game_random, game_toolbox, game_ticks};
  game.initial_stack_ticks = runtime->initial_stack_ticks;
  game.history_user = e;
  game.append = game_append;
  if (!maven_commit_game_turn(&game, move, e->collector_ids,
                              e->collector_weights, &workspace))
    error = MAVEN_ENGINE_CAPACITY;
  if (e->diagnostics)
    error = MAVEN_ENGINE_DIAGNOSTIC;
  if (inputs.failed)
    error = MAVEN_ENGINE_EXTERNAL;
  if (error == MAVEN_ENGINE_OK && game.phase == 4 && !maven_finish_game(&game))
    error = MAVEN_ENGINE_CAPACITY;
  if (error != MAVEN_ENGINE_OK) {
    e->history.count = old_count;
    e->history.used = old_used;
    e->branch_pending = old_branch;
    return error;
  }
  for (i = 0; i < 225; i++) {
    unsigned k = (i / 15 + 1) * 17 + i % 15 + 1;
    e->position.letters[i] = e->board[k];
    e->position.blanks[i] = (uint8_t)(e->board[k] && !e->values[k]);
  }
  memcpy(e->position.racks, e->racks, sizeof e->racks);
  memcpy(e->position.score_bits, game.totals, sizeof game.totals);
  e->position.row_zero_count = (uint16_t)e->application.row_zero_count;
  e->position.side = (uint8_t)game.selected_side;
  e->finished = game.phase == 5;
  e->has_ranking = 0;
  memcpy(e->statistics, game.statistics, sizeof e->statistics);
  memcpy(output.move, move, 34);
  memcpy(output.features, game.features, sizeof output.features);
  memcpy(output.statistics, game.statistics, sizeof output.statistics);
  output.evaluation_bits = game.evaluation_result.total_bits;
  output.phase = game.phase;
  output.selected_side = game.selected_side;
  output.history_records = e->history.count;
  runtime->private_seed = inputs.seed;
  *result = output;
  return MAVEN_ENGINE_OK;
}
MavenEngineResult maven_portable_save(MavenPortableEngine *e, uint8_t *output,
                                      size_t capacity, size_t *length) {
  MavenHistoryResult result;
  if (!e || !length)
    return MAVEN_ENGINE_INVALID;
  if (!e->ready)
    return MAVEN_ENGINE_NO_POSITION;
  if (!e->history.count || e->branch_pending) {
    prepare_game(e);
    if (start_history(e) != MAVEN_ENGINE_OK)
      return MAVEN_ENGINE_CAPACITY;
  }
  result = maven_encode_history_records(e->history.records, e->history.count,
                                        output, capacity, length);
  return result == MAVEN_HISTORY_OK         ? MAVEN_ENGINE_OK
         : result == MAVEN_HISTORY_CAPACITY ? MAVEN_ENGINE_CAPACITY
                                            : MAVEN_ENGINE_INVALID;
}

static int history_rack_valid(const uint8_t *rack) {
  unsigned i;
  for (i = 0; i < 8; i++) {
    uint8_t c = rack[i];
    if (!c)
      return 1;
    if (c != '?' && (c < 'a' || c > 'z'))
      return 0;
  }
  return 0;
}
static int history_records_valid(const MavenHistoryRecord *records,
                                 size_t count) {
  size_t i;
  for (i = 0; i < count; i++) {
    const MavenHistoryRecord *r = records + i;
    const uint8_t *p = r->payload;
    unsigned n;
    size_t need = r->tag == 0   ? 300
                  : r->tag == 1 ? 22
                  : r->tag == 2 ? 52
                  : r->tag == 3 ? 18
                                : 0;
    if (r->tag < 0 || r->tag > 4 || r->length < need)
      return 0;
    if (r->tag == 0) {
      for (n = 0; n < 272; n++) {
        uint8_t c = p[n];
        if (c && (c < 'a' || c > 'z' || n < 17 || n % 17 == 0 || n % 17 == 16))
          return 0;
      }
      if (!history_rack_valid(p + 272) || !history_rack_valid(p + 280))
        return 0;
      for (n = 296; n < 300; n++)
        if (p[n] > 15)
          return 0;
    } else if (r->tag == 1) {
      if (!history_rack_valid(p + 6) || !history_rack_valid(p + 14))
        return 0;
    } else if (r->tag == 2) {
      if (!history_rack_valid(p + 36) || !history_rack_valid(p + 44) ||
          p[32] > 30)
        return 0;
      for (n = 0; n < 16 && p[n]; n++)
        if ((p[n] < 'a' || p[n] > 'z') && (p[32] || p[n] != '?'))
          return 0;
      if (n == 16)
        return 0;
    } else if (r->tag == 3 && !history_rack_valid(p + 2))
      return 0;
  }
  return 1;
}
static int working_inventory_valid(MavenPortableEngine *e) {
  unsigned used[128] = {0}, r, c, s;
  int occupied = 0;
  for (r = 1; r <= 15; r++)
    for (c = 1; c <= 15; c++) {
      unsigned k = r * 17 + c;
      uint8_t letter = e->board[k];
      if (letter) {
        if (letter < 'a' || letter > 'z')
          return 0;
        ++used[e->values[k] ? letter : '?'];
        occupied = 1;
      }
    }
  if (occupied && !e->board[144])
    return 0;
  for (s = 0; s < 2; s++) {
    if (!history_rack_valid(e->racks[s]))
      return 0;
    for (c = 0; e->racks[s][c]; c++)
      ++used[e->racks[s][c]];
  }
  for (c = 0; c < 128; c++)
    if (used[c] > e->tables.distribution[c])
      return 0;
  return 1;
}
typedef struct {
  MavenPortableEngine *engine;
  MavenHistoryRuntime *runtime;
  GameInputs inputs;
  int invalid;
} HistoryInputs;
static int history_refill(void *user, unsigned side) {
  HistoryInputs *h = user;
  MavenPortableEngine *e = h->engine;
  uint8_t bag[128];
  uint32_t length, initial;
  MavenRefillOps ops = {&h->inputs, game_random, game_toolbox, game_ticks};
  if (side > 1 || !working_inventory_valid(e)) {
    h->invalid = 1;
    return 0;
  }
  initial = h->runtime->random.initial_stack_ticks;
  if (h->runtime->begin_refill &&
      !h->runtime->begin_refill(h->runtime->random.user, &initial)) {
    h->inputs.failed = 1;
    return 0;
  }
  h->inputs.last_ticks = initial;
  length = maven_collect_remaining_tiles(bag, e->tables.distribution, e->board,
                                         e->values, e->racks[0], e->racks[1],
                                         e->tables.alphabet);
  maven_refill_rack_from_bag(e->racks[side], bag, length, e->board, initial,
                             &ops);
  return !h->inputs.failed;
}
static void history_checkpoint(void *user, size_t index, int tag) {
  HistoryInputs *h = user;
  (void)index;
  (void)tag;
  if (!working_inventory_valid(h->engine)) {
    h->invalid = 1;
    h->engine->diagnostics = 1;
  }
}
static MavenEngineResult restore_records(MavenPortableEngine *e,
                                         const MavenHistoryRecord *records,
                                         size_t count, size_t index,
                                         int selection,
                                         MavenHistoryRuntime *runtime) {
  MavenPosition previous = e->position, next = {0};
  MavenHistoryPlayback playback = {0};
  HistoryInputs h;
  MavenPlaybackResult status;
  unsigned i;
  if (!runtime || !runtime->random.read_ticks ||
      !runtime->random.toolbox_random || !runtime->random.private_seed ||
      runtime->random.private_seed > 0x7fffffff || index >= count ||
      !history_records_valid(records, count))
    return MAVEN_ENGINE_INVALID;
  memset(&e->position, 0, sizeof e->position);
  prepare_search(e);
  e->position = previous;
  e->diagnostics = 0;
  h = (HistoryInputs){e,
                      runtime,
                      {&runtime->random, runtime->random.private_seed,
                       runtime->random.initial_stack_ticks, 0, 0},
                      0};
  playback.application = &e->application;
  playback.racks[0] = e->racks[0];
  playback.racks[1] = e->racks[1];
  playback.display_order = e->tables.display_order;
  playback.records = records;
  playback.count = count;
  playback.refill = history_refill;
  playback.checkpoint = history_checkpoint;
  playback.user = &h;
  status = maven_restore_history_index(&playback,
                                       selection && index ? index - 1 : index);
  if (status == MAVEN_PLAYBACK_OK && selection)
    status = maven_prepare_history_selection(&playback, index);
  if (h.invalid || status == MAVEN_PLAYBACK_INVALID ||
      !working_inventory_valid(e))
    return MAVEN_ENGINE_INVALID;
  if (h.inputs.failed || status == MAVEN_PLAYBACK_REFILL_FAILED)
    return MAVEN_ENGINE_EXTERNAL;
  if (e->diagnostics)
    return MAVEN_ENGINE_DIAGNOSTIC;
  for (i = 0; i < 225; i++) {
    unsigned k = (i / 15 + 1) * 17 + i % 15 + 1;
    next.letters[i] = e->board[k];
    next.blanks[i] = (uint8_t)(e->board[k] && !e->values[k]);
  }
  memcpy(next.racks, e->racks, sizeof next.racks);
  memcpy(next.score_bits, playback.totals, sizeof next.score_bits);
  next.row_zero_count = (uint16_t)e->application.row_zero_count;
  next.side = (uint8_t)playback.selected_side;
  e->finished = !next.racks[0][0] || !next.racks[1][0];
  if (e->finished)
    next.side = 2;
  e->position = next;
  e->ready = 1;
  e->has_ranking = 0;
  e->branch_pending = selection && !e->finished;
  memset(e->statistics, 0, sizeof e->statistics);
  runtime->random.private_seed = h.inputs.seed;
  return MAVEN_ENGINE_OK;
}
typedef struct {
  MavenHistoryRecord records[512];
  uint8_t bytes[65536];
} HistoryImport;
MavenEngineResult maven_portable_load(MavenPortableEngine *e,
                                      const uint8_t *wire, size_t length,
                                      MavenHistoryRuntime *runtime) {
  HistoryImport *import;
  MavenHistoryStore staged;
  MavenHistoryResult decoded;
  MavenEngineResult result;
  size_t count;
  if (!e || !wire || !length || !runtime)
    return MAVEN_ENGINE_INVALID;
  decoded = maven_decode_history_records(wire, length, NULL, 0, &count);
  if (decoded != MAVEN_HISTORY_CAPACITY)
    return MAVEN_ENGINE_INVALID;
  if (count > 512 || length - 4 * count > 65536)
    return MAVEN_ENGINE_CAPACITY;
  import = e->allocator.allocate(e->allocator.user, sizeof *import);
  if (!import)
    return MAVEN_ENGINE_ALLOCATION;
  staged = (MavenHistoryStore){import->records, 0, 512,
                               import->bytes,   0, sizeof import->bytes};
  decoded = maven_history_store_load(&staged, wire, length);
  result = decoded == MAVEN_HISTORY_OK
               ? restore_records(e, staged.records, staged.count,
                                 staged.count - 1, 0, runtime)
               : MAVEN_ENGINE_INVALID;
  if (result == MAVEN_ENGINE_OK) {
    e->history =
        (MavenHistoryStore){e->history_records, 0, 512,
                            e->history_bytes,   0, sizeof e->history_bytes};
    /* Copy only the staged owned payloads; callbacks may have changed the
     * caller's input buffer. All capacities were checked before replay. */
    for (size_t i = 0; i < staged.count; i++)
      (void)maven_history_store_append(&e->history, staged.records[i].tag,
                                       staged.records[i].payload,
                                       staged.records[i].length);
  }
  e->allocator.release(e->allocator.user, import);
  return result;
}
MavenEngineResult maven_portable_history_select(MavenPortableEngine *e,
                                                size_t index,
                                                MavenHistoryRuntime *runtime) {
  if (!e || !runtime)
    return MAVEN_ENGINE_INVALID;
  if (!e->ready)
    return MAVEN_ENGINE_NO_POSITION;
  return restore_records(e, e->history.records, e->history.count, index, 1,
                         runtime);
}
size_t maven_portable_history_count(const MavenPortableEngine *e) {
  return e ? e->history.count : 0;
}

typedef struct {
  MavenPortableEngine *engine;
  const MavenSimulationOptions *options;
  MavenHistoryRuntime *runtime;
  GameInputs inputs;
  MavenHeuristicSearch heuristic;
  MavenSearchDispatch dispatch;
  MavenSimulationResult output;
  int cancelled, invalid;
} SimulationInputs;
static int simulation_cancel(void *user) {
  SimulationInputs *s = user;
  if (s->options->runtime_failed &&
      s->options->runtime_failed(s->options->user))
    s->inputs.failed = 1;
  if (s->options->cancel_requested &&
      s->options->cancel_requested(s->options->user))
    s->cancelled = 1;
  return s->cancelled || s->inputs.failed || s->invalid ||
         s->engine->diagnostics;
}
static int32_t simulation_elapsed(void *user) {
  SimulationInputs *s = user;
  return s->options->elapsed_seconds(s->options->user);
}
static uint32_t simulation_calibration(void *user) {
  SimulationInputs *s = user;
  return s->options->late_calibration(s->options->user);
}
static uint32_t simulation_stack_ticks(void *user) {
  SimulationInputs *s = user;
  uint32_t initial = s->runtime->random.initial_stack_ticks;
  s->inputs.events = 0;
  if (s->runtime->begin_refill &&
      !s->runtime->begin_refill(s->runtime->random.user, &initial))
    s->inputs.failed = 1;
  s->inputs.last_ticks = initial;
  return initial;
}
static void simulation_refill(void *user, int side) {
  SimulationInputs *s = user;
  MavenPortableEngine *e = s->engine;
  uint8_t bag[128];
  uint32_t length, initial;
  MavenRefillOps ops = {&s->inputs, game_random, game_toolbox, game_ticks};
  if (side < 0 || side > 1 || !working_inventory_valid(e)) {
    s->invalid = 1;
    return;
  }
  initial = simulation_stack_ticks(s);
  length = maven_collect_remaining_tiles(bag, e->tables.distribution, e->board,
                                         e->values, e->racks[0], e->racks[1],
                                         e->tables.alphabet);
  maven_refill_rack_from_bag(e->racks[side], bag, length, e->board, initial,
                             &ops);
}
static void simulation_select(void *user, int side, uint8_t move[34]) {
  SimulationInputs *s = user;
  MavenPortableEngine *e = s->engine;
  uint8_t unseen[128] = {0};
  int total;
  maven_count_rack(e->counts, e->tables.alphabet, e->racks[side]);
  total = maven_count_unseen_tiles(unseen, e->tables.distribution, e->board,
                                   e->values, e->counts, e->tables.alphabet);
  if (maven_choose_search_kind((int16_t)total, s->options->endgame_enabled,
                               s->options->late_enabled) ==
      MAVEN_SEARCH_ENDGAME) {
    if (!maven_initialize_hash_table(e->hash, &s->inputs.seed)) {
      s->invalid = 1;
      memset(move, 0, 34);
      return;
    }
    if (s->options->endgame_started)
      s->options->endgame_started(s->options->user);
  }
  memcpy(s->dispatch.selected_move, e->rollout.selected_move, 34);
  if (!maven_select_best_move_shared(
          &s->dispatch, e->racks[side], e->racks[1 - side],
          e->tables.globals + MAVEN_GLOBAL_BYTES - 0x6f2))
    s->invalid = 1;
  if (e->endgame.was_cancelled)
    s->cancelled = 1;
  if (s->cancelled || s->invalid)
    memset(move, 0, 34);
  else
    memcpy(move, s->dispatch.selected_move, 34);
}
static void simulation_publish(void *user, const uint8_t *moves,
                               unsigned count) {
  SimulationInputs *s = user;
  if (count > 10) {
    s->invalid = 1;
    return;
  }
  memcpy(s->output.published, moves, count * 34);
  s->output.publications++;
  if (s->options->publish)
    s->options->publish(s->options->user, moves, count);
}
static void simulation_event(void *user, MavenRolloutEvent kind,
                             unsigned candidate, unsigned reply) {
  SimulationInputs *s = user;
  if (s->options->event)
    s->options->event(s->options->user, (int)kind, candidate, reply);
}
MavenEngineResult maven_portable_simulate(MavenPortableEngine *e,
                                          const MavenSimulationOptions *options,
                                          MavenHistoryRuntime *runtime,
                                          MavenSimulationResult *result) {
  SimulationInputs inputs;
  MavenSimulationSession *session;
  MavenRolloutSearch *rollout;
  uint8_t unseen[128] = {0}, sorted[8];
  uint32_t saved_hash[16];
  int total;
  unsigned i;
  MavenSimulationStatus status;
  if (!e || !options || !runtime || !result || !runtime->random.read_ticks ||
      !runtime->random.toolbox_random || !runtime->random.private_seed ||
      runtime->random.private_seed > 0x7fffffff || options->lookahead < 1 ||
      options->lookahead > 16383 ||
      (options->exhaustive != 0 && options->exhaustive != 1) ||
      (options->late_enabled != 0 && options->late_enabled != 1) ||
      (options->endgame_enabled != 0 && options->endgame_enabled != 1) ||
      (!options->exhaustive && !options->sample_limit) ||
      (options->late_enabled && !options->late_calibration) ||
      (options->endgame_enabled &&
       (!options->elapsed_seconds || options->endgame_budget_seconds < 0)))
    return MAVEN_ENGINE_INVALID;
  if (!e->ready)
    return MAVEN_ENGINE_NO_POSITION;
  if (e->finished)
    return MAVEN_ENGINE_UNSUPPORTED;
  if (!e->has_ranking || !e->last_ranking.count)
    return MAVEN_ENGINE_INVALID;
  memcpy(saved_hash, e->hash, sizeof saved_hash);
  memset(&inputs, 0, sizeof inputs);
  inputs.engine = e;
  inputs.options = options;
  inputs.runtime = runtime;
  inputs.inputs = (GameInputs){&runtime->random, runtime->random.private_seed,
                               runtime->random.initial_stack_ticks, 0, 0};
  prepare_search(e);
  e->diagnostics = 0;
  maven_count_rack(e->counts, e->tables.alphabet, e->racks[0]);
  total = maven_count_unseen_tiles(unseen, e->tables.distribution, e->board,
                                   e->values, e->counts, e->tables.alphabet);
  if (options->exhaustive && (total < 7 || total > 17))
    return MAVEN_ENGINE_UNSUPPORTED;
  if (!configure_late(e, 0))
    return MAVEN_ENGINE_INVALID;
  configure_endgame(e);
  for (i = 0; i < 54; i++)
    e->late_workload[i / 9][i % 9] =
        read16(e->tables.globals + MAVEN_GLOBAL_BYTES - 0x89a + 2 * i);
  e->ranking = e->last_ranking;
  maven_rack_from_counts(sorted, e->counts, e->tables.alphabet);
  e->leaves.sorted_rack = sorted;
  e->leaves.unseen_counts = unseen;
  maven_prepare_leave_table(&e->leaves);
  inputs.heuristic.sections = e->sections;
  inputs.heuristic.evaluation = &e->evaluation;
  inputs.heuristic.leaves = &e->leaves;
  inputs.heuristic.result = &e->ranking;
  inputs.heuristic.opponent_rack = e->racks[1];
  inputs.heuristic.row_flags = e->tables.globals + MAVEN_GLOBAL_BYTES - 0x6d2;
  inputs.dispatch.heuristic = &inputs.heuristic;
  inputs.dispatch.late = &e->late;
  inputs.dispatch.endgame = &e->endgame;
  inputs.dispatch.late_enabled = options->late_enabled;
  inputs.dispatch.endgame_enabled = options->endgame_enabled;
  inputs.dispatch.endgame_budget_seconds = options->endgame_budget_seconds;
  inputs.dispatch.late_workload = e->late_workload;
  inputs.dispatch.late_calibration = simulation_calibration;
  inputs.dispatch.late_calibration_user = &inputs;
  e->endgame.user = &inputs;
  e->endgame.elapsed_seconds = simulation_elapsed;
  e->endgame.cancel_requested = simulation_cancel;
  rollout = &e->rollout;
  memset(rollout, 0, sizeof *rollout);
  rollout->application = &e->application;
  rollout->racks[0] = e->racks[0];
  rollout->racks[1] = e->racks[1];
  rollout->entries = e->simulation_entries;
  rollout->count = (uint16_t)maven_seed_simulation_candidates(
      e->simulation_entries, e->last_ranking.moves[0], e->last_ranking.count);
  rollout->reply_plies =
      maven_simulation_reply_plies((int16_t)options->lookahead);
  rollout->select = simulation_select;
  rollout->refill = simulation_refill;
  rollout->observe = simulation_event;
  rollout->cancelled = simulation_cancel;
  rollout->user = &inputs;
  memcpy(rollout->selected_move, e->last_ranking.moves[0], 34);
  session = &e->simulation;
  memset(session, 0, sizeof *session);
  session->rollout = rollout;
  session->leaves = &e->leaves;
  session->distribution = e->tables.distribution;
  session->choose = (const uint16_t (*)[8])e->late_tables;
  session->random =
      (MavenRefillOps){&inputs.inputs, game_random, game_toolbox, game_ticks};
  session->stack_ticks = simulation_stack_ticks;
  session->clock_user = &inputs;
  session->limit_bits = options->sample_limit;
  session->publish = simulation_publish;
  session->user = &inputs;
  if (!maven_begin_simulation_session(session))
    return MAVEN_ENGINE_DIAGNOSTIC;
  if (simulation_cancel(&inputs))
    status =
        maven_finish_simulation_session(session, MAVEN_SIMULATION_CANCELLED);
  else if (options->exhaustive)
    status = maven_run_exhaustive_session(session);
  else {
    do {
      status = maven_step_simulation_session(session);
    } while (status == MAVEN_SIMULATION_RUNNING && !simulation_cancel(&inputs));
    if (status == MAVEN_SIMULATION_RUNNING)
      status =
          maven_finish_simulation_session(session, MAVEN_SIMULATION_CANCELLED);
  }
  if (options->runtime_failed && options->runtime_failed(options->user))
    inputs.inputs.failed = 1;
  if (inputs.inputs.failed) {
    memcpy(e->hash, saved_hash, sizeof saved_hash);
    return MAVEN_ENGINE_EXTERNAL;
  }
  if (inputs.invalid || e->diagnostics || status == MAVEN_SIMULATION_ERROR) {
    memcpy(e->hash, saved_hash, sizeof saved_hash);
    return MAVEN_ENGINE_DIAGNOSTIC;
  }
  inputs.output.count = rollout->count;
  inputs.output.status = (unsigned)status;
  inputs.output.batches = session->batches;
  inputs.output.total_weight = session->total_weight;
  memcpy(inputs.output.entries, e->simulation_entries, rollout->count * 46);
  if (inputs.output.publications) {
    memcpy(e->last_ranking.moves, inputs.output.published,
           sizeof e->last_ranking.moves);
    e->last_ranking.count = (uint16_t)inputs.output.count;
    e->last_ranking.cutoff_bits =
        maven_move_rank_bits(e->last_ranking.moves[9]);
  }
  runtime->random.private_seed = inputs.inputs.seed;
  *result = inputs.output;
  return status == MAVEN_SIMULATION_CANCELLED ? MAVEN_ENGINE_CANCELLED
                                              : MAVEN_ENGINE_OK;
}
