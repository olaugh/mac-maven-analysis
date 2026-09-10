/* Application extension of the owned portable engine.
 *
 * This file includes the unmodified reconstruction/portable_engine.c so it can
 * reach the private engine structure, then adds the operations a playable
 * application needs but the research API deliberately left out: committing a
 * human-entered move or exchange through the same CODE11 turn commit that the
 * original uses, dealing a new game with the original refill routine,
 * selecting the active lexicon sections, dictionary membership for challenge
 * decisions, Word List enumeration and per-player statistics.
 *
 * Nothing here changes how a ranked move is searched or committed. */
#include "portable_engine.c"
#include "portable_engine_app.h"
#include "query_prepare.h"
#include "word_enumerator.h"

typedef struct {
  MavenDisplayMoveScore display;
  uint32_t score;
  int called;
} DryScore;

static void dry_scored(void *user, uint8_t copy[34]) {
  DryScore *d = user;
  maven_score_display_move(&d->display, copy);
  d->score = read32(copy + 16);
  d->called = 1;
}

static void build_display(const MavenPortableEngine *e, uint8_t display[289]) {
  unsigned i;
  for (i = 0; i < 289; i++)
    display[i] = e->board[i] && e->values[i] ? (uint8_t)(e->board[i] - 'a' + 'A')
                                             : e->board[i];
}

/* Shared tail of a human commit: mirrors maven_portable_play_ranked from the
 * history reservation onward, with the caller's fully formed record. */
static MavenEngineResult commit_record(MavenPortableEngine *e, uint8_t move[34],
                                       const uint8_t display[289],
                                       MavenGameRuntime *runtime,
                                       MavenGameResult *result) {
  MavenGameTurn game = {0};
  MavenAppliedMove workspace = {{0}, 0};
  MavenDisplayMoveScore display_score;
  MavenGameResult output = {0};
  GameInputs inputs;
  size_t old_count, old_used;
  unsigned i, side;
  int old_branch;
  MavenEngineResult error = MAVEN_ENGINE_OK;
  if (e->history.record_capacity - e->history.count <
          (e->history.count && !e->branch_pending ? 3u : 5u) ||
      e->history.byte_capacity - e->history.used <
          (e->history.count && !e->branch_pending ? 88u : 388u))
    return MAVEN_ENGINE_CAPACITY;
  side = e->position.side;
  old_count = e->history.count;
  old_used = e->history.used;
  old_branch = e->branch_pending;
  prepare_game(e);
  if (side == 0 && display) {
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

static int runtime_valid(const MavenGameRuntime *runtime) {
  return runtime && runtime->read_ticks && runtime->toolbox_random &&
         runtime->private_seed && runtime->private_seed <= 0x7fffffff;
}

MavenEngineResult maven_app_play_move(MavenPortableEngine *e,
                                      const MavenAppMove *m,
                                      MavenGameRuntime *runtime,
                                      MavenGameResult *result) {
  uint8_t move[34] = {0}, display[289], counts[128] = {0};
  unsigned i, length = 0, fresh = 0, side;
  DryScore dry;
  if (!e || !m || !result || !runtime_valid(runtime))
    return MAVEN_ENGINE_INVALID;
  if (!e->ready)
    return MAVEN_ENGINE_NO_POSITION;
  if (e->finished)
    return MAVEN_ENGINE_UNSUPPORTED;
  if (m->row > 14 || m->column > 14 || (m->vertical != 0 && m->vertical != 1))
    return MAVEN_ENGINE_INVALID;
  while (length < 16 && m->word[length])
    ++length;
  if (length < 2 || length > 15 || (m->vertical ? m->row : m->column) + length > 15)
    return MAVEN_ENGINE_INVALID;
  side = e->position.side;
  prepare_game(e);
  build_display(e, display);
  for (i = 0; i < 8 && e->racks[side][i]; i++)
    ++counts[e->racks[side][i]];
  for (i = 0; i < length; i++) {
    uint8_t c = m->word[i];
    unsigned row = m->row + (m->vertical ? i : 0),
             column = m->column + (m->vertical ? 0 : i),
             cell = (row + 1) * 17 + column + 1;
    if (c < 'a' || c > 'z')
      return MAVEN_ENGINE_INVALID;
    if (e->board[cell]) {
      if (e->board[cell] != c || m->new_tile[i])
        return MAVEN_ENGINE_INVALID;
    } else {
      uint8_t tile = m->blank[i] ? '?' : c;
      if (!m->new_tile[i] || !counts[tile])
        return MAVEN_ENGINE_INVALID;
      --counts[tile];
      ++fresh;
      display[cell] = m->blank[i] ? c : (uint8_t)(c - 'a' + 'A');
    }
    move[i] = c;
  }
  if (!fresh)
    return MAVEN_ENGINE_INVALID;
  move[32] = (uint8_t)(m->vertical ? m->column + 16 : m->row + 1);
  move[33] = (uint8_t)(m->vertical ? m->row + 1 : m->column + 1);
  /* Score exactly as the original stages a human move: the CODE8 display
   * scorer runs against the staged grid during a preliminary application,
   * then the real commit starts again from the untouched position. */
  {
    uint32_t features[22];
    MavenAppliedMove workspace = {{0}, 0};
    memset(&dry, 0, sizeof dry);
    dry.display = (MavenDisplayMoveScore){&e->application, display,
                                          e->tables.classes, e->racks[side]};
    e->application.scored_move = dry_scored;
    e->application.callback_user = &dry;
    maven_apply_evaluated_move(move, &e->evaluation, features,
                               e->collector_ids, e->collector_weights,
                               &workspace);
    e->application.scored_move = NULL;
    e->application.callback_user = NULL;
    if (e->diagnostics || !dry.called)
      return MAVEN_ENGINE_DIAGNOSTIC;
    prepare_game(e);
    build_display(e, display);
    for (i = 0; i < length; i++) {
      unsigned row = m->row + (m->vertical ? i : 0),
               column = m->column + (m->vertical ? 0 : i),
               cell = (row + 1) * 17 + column + 1;
      if (m->new_tile[i])
        display[cell] = m->blank[i] ? m->word[i] : (uint8_t)(m->word[i] - 'a' + 'A');
    }
    move[16] = (uint8_t)(dry.score >> 24);
    move[17] = (uint8_t)(dry.score >> 16);
    move[18] = (uint8_t)(dry.score >> 8);
    move[19] = (uint8_t)dry.score;
  }
  return commit_record(e, move, display, runtime, result);
}

MavenEngineResult maven_app_play_exchange(MavenPortableEngine *e,
                                          const uint8_t *tiles,
                                          MavenGameRuntime *runtime,
                                          MavenGameResult *result) {
  uint8_t move[34] = {0}, counts[128] = {0};
  unsigned i, n = 0, side;
  if (!e || !tiles || !result || !runtime_valid(runtime))
    return MAVEN_ENGINE_INVALID;
  if (!e->ready)
    return MAVEN_ENGINE_NO_POSITION;
  if (e->finished)
    return MAVEN_ENGINE_UNSUPPORTED;
  side = e->position.side;
  for (i = 0; i < 8 && e->position.racks[side][i]; i++)
    ++counts[e->position.racks[side][i]];
  while (tiles[n]) {
    uint8_t c = tiles[n];
    if (n >= 7 || (c != '?' && (c < 'a' || c > 'z')) || !counts[c])
      return MAVEN_ENGINE_INVALID;
    --counts[c];
    move[n++] = c;
  }
  if (n) {
    /* An exchange needs at least seven unseen tiles in the bag: total unseen
     * minus the opponent's rack. */
    unsigned used = 0, total = 0, other = 0;
    for (i = 0; i < 225; i++)
      if (e->position.letters[i])
        ++used;
    for (i = 0; i < 2; i++) {
      unsigned k = 0;
      while (k < 8 && e->position.racks[i][k])
        ++k;
      used += k;
      if (i != side)
        other = k;
    }
    for (i = 0; i < 128; i++)
      total += e->tables.distribution[i];
    (void)other;
    if (total - used < 7)
      return MAVEN_ENGINE_UNSUPPORTED;
  }
  return commit_record(e, move, NULL, runtime, result);
}

MavenEngineResult maven_app_deal(MavenPortableEngine *e, unsigned first_side,
                                 MavenGameRuntime *runtime) {
  MavenPosition p = {0};
  GameInputs inputs;
  MavenRefillOps ops;
  uint8_t bag[128];
  uint32_t length;
  unsigned s;
  if (!e || first_side > 1 || !runtime_valid(runtime))
    return MAVEN_ENGINE_INVALID;
  p.side = (uint8_t)first_side;
  e->position = p;
  e->ready = 1;
  prepare_game(e);
  inputs = (GameInputs){runtime, runtime->private_seed,
                        runtime->initial_stack_ticks, 0, 0};
  ops = (MavenRefillOps){&inputs, game_random, game_toolbox, game_ticks};
  for (s = 0; s < 2; s++) {
    e->racks[s][0] = 0;
    length = maven_collect_remaining_tiles(bag, e->tables.distribution,
                                           e->board, e->values, e->racks[0],
                                           e->racks[1], e->tables.alphabet);
    maven_refill_rack_from_bag(e->racks[s], bag, length, e->board,
                               runtime->initial_stack_ticks, &ops);
    if (inputs.failed)
      return MAVEN_ENGINE_EXTERNAL;
    maven_count_rack(e->counts, e->tables.alphabet, e->racks[s]);
    maven_rack_from_counts(e->racks[s], e->counts,
                           s == 0 ? e->tables.display_order
                                  : e->tables.alphabet);
  }
  memcpy(p.racks, e->racks, sizeof p.racks);
  runtime->private_seed = inputs.seed;
  return maven_portable_set_position(e, &p);
}

static MavenDictionarySection app_base_sections[3];
void maven_app_capture_lexicon(const MavenPortableEngine *e) {
  if (e)
    memcpy(app_base_sections, e->sections, sizeof app_base_sections);
}
MavenEngineResult maven_app_set_lexicon(MavenPortableEngine *e, unsigned mode) {
  if (!e || mode > 2 || !app_base_sections[0].root_index)
    return MAVEN_ENGINE_INVALID;
  memset(e->sections, 0, sizeof e->sections);
  if (mode == 2) {
    e->sections[0] = app_base_sections[0];
    e->sections[1] = app_base_sections[1];
  } else
    e->sections[0] = app_base_sections[mode];
  return MAVEN_ENGINE_OK;
}

int maven_app_word_acceptable(const MavenPortableEngine *e, const uint8_t *word) {
  if (!e || !word || !word[0])
    return 0;
  return maven_terminated_sections_contain(e->sections, word);
}

void maven_app_statistics(const MavenPortableEngine *e, uint32_t out[2][22]) {
  if (e && out)
    memcpy(out, e->statistics, sizeof e->statistics);
}

int maven_app_unseen(const MavenPortableEngine *e, uint8_t counts[128]) {
  MavenPortableEngine *w = (MavenPortableEngine *)e;
  uint8_t rack_counts[128] = {0};
  int total;
  if (!e || !e->ready)
    return -1;
  prepare_search(w);
  maven_count_rack(rack_counts, w->tables.alphabet, w->racks[0]);
  memset(counts, 0, 128);
  total = maven_count_unseen_tiles(counts, w->tables.distribution, w->board,
                                   w->values, rack_counts, w->tables.alphabet);
  return total;
}

typedef struct {
  void (*emit)(void *, const uint8_t *);
  void *user;
} WordListSink;

static void word_list_append(void *user, const uint8_t *word) {
  WordListSink *s = user;
  s->emit(s->user, word);
}

int maven_app_word_list(MavenPortableEngine *e, const uint8_t *rack,
                        const uint8_t *on_board, const uint8_t *prefix,
                        const uint8_t *suffix, int bingos, int minimum,
                        int maximum, void (*emit)(void *, const uint8_t *),
                        void *user) {
  MavenWordEnumeration state;
  WordListSink sink = {emit, user};
  uint8_t required[128];
  int16_t section;
  if (!e || !rack || !on_board || !prefix || !suffix || !emit)
    return -1;
  memset(&state, 0, sizeof state);
  state.sections = e->sections;
  state.append_word = word_list_append;
  state.user = &sink;
  maven_prepare_word_query(&state, rack, on_board, prefix, suffix, bingos,
                           required);
  /* Empty Word List length fields mean any playable length. */
  state.minimum_length = (int16_t)(minimum > 0 ? minimum : 2);
  state.maximum_length = (int16_t)(maximum > 0 ? maximum : 15);
  for (section = 0; section < 3 && e->sections[section].root_index; section++) {
    state.current_section = section;
    maven_enumerate_section(&state);
  }
  return state.result_count;
}

const uint16_t *maven_app_letter_values(const MavenPortableEngine *e) {
  return e ? e->tables.letter_values : NULL;
}
const uint8_t *maven_app_distribution(const MavenPortableEngine *e) {
  return e ? e->tables.distribution : NULL;
}

/* Playing levels now live in reconstruction/playing_level.c and the
 * maven_portable_heuristic_leveled entry; the wasm app calls those directly. */

