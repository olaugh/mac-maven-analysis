#ifndef MAVEN_PORTABLE_ENGINE_APP_H
#define MAVEN_PORTABLE_ENGINE_APP_H
#include "portable_engine.h"
/* A human-entered placement. word is the complete main word (existing tiles
 * included), lowercase, at most 15 letters; row/column are zero-based board
 * coordinates of its first letter. new_tile[i] marks letters supplied from
 * the rack; blank[i] marks those played as the blank. */
typedef struct {
  uint8_t word[16];
  uint8_t new_tile[16], blank[16];
  unsigned row, column, vertical;
} MavenAppMove;
/* Commit a human move through the original CODE11 turn commit, scoring it
 * with the CODE8 staged-display scorer as the original UI does. Rejects
 * tiles missing from the mover's rack, occupied squares and letters that do
 * not match existing tiles. Word legality is not checked here. */
MavenEngineResult maven_app_play_move(MavenPortableEngine *, const MavenAppMove *,
                                      MavenGameRuntime *, MavenGameResult *);
/* Exchange the listed rack tiles ('?' for a blank); an empty list passes. */
MavenEngineResult maven_app_play_exchange(MavenPortableEngine *, const uint8_t *tiles,
                                          MavenGameRuntime *, MavenGameResult *);
/* Start a new game: empty board, both racks drawn with the original refill
 * routine, given side to move first. */
MavenEngineResult maven_app_deal(MavenPortableEngine *, unsigned first_side,
                                 MavenGameRuntime *);
/* Record the freshly created engine's two dictionary sections, then select
 * 0 North American (section 1), 1 United Kingdom (section 2) or 2 both. */
void maven_app_capture_lexicon(const MavenPortableEngine *);
MavenEngineResult maven_app_set_lexicon(MavenPortableEngine *, unsigned mode);
int maven_app_word_acceptable(const MavenPortableEngine *, const uint8_t *word);
void maven_app_statistics(const MavenPortableEngine *, uint32_t out[2][22]);
/* Unseen counts from the mover's perspective; returns the total or -1. */
int maven_app_unseen(const MavenPortableEngine *, uint8_t counts[128]);
int maven_app_word_list(MavenPortableEngine *, const uint8_t *rack,
                        const uint8_t *on_board, const uint8_t *prefix,
                        const uint8_t *suffix, int bingos, int minimum,
                        int maximum, void (*emit)(void *, const uint8_t *),
                        void *user);
const uint16_t *maven_app_letter_values(const MavenPortableEngine *);
const uint8_t *maven_app_distribution(const MavenPortableEngine *);
#endif
