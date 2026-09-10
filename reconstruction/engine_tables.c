#include "engine_tables.h"
#include "global_initializer.h"
#include "score_statistics.h"
#include <string.h>
static uint16_t be16(const uint8_t *p) {
  return (uint16_t)((unsigned)p[0] * 256 + p[1]);
}
static uint32_t be32(const uint8_t *p) {
  return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 |
         p[3];
}
static int sb(uint8_t x) { return x < 128 ? x : (int)x - 256; }
static int has(MavenBlob b, size_t minimum) {
  return b.data && b.size >= minimum;
}
static int score_words(uint32_t out[8], MavenBlob b) {
  unsigned i;
  uint8_t copy[28];
  if (!has(b, 224))
    return 0;
  for (i = 0; i < 8; i++) {
    memcpy(copy, b.data + 28 * i, 28);
    if (!maven_initialize_score_record(copy))
      return 0;
    out[i] = be32(copy + 24);
  }
  return 1;
}
static void words(uint16_t *out, const uint8_t *p, size_t count) {
  size_t i;
  for (i = 0; i < count; i++)
    out[i] = be16(p + 2 * i);
}
static int pattern_valid(const MavenEngineTables *t) {
  int i;
  size_t score_bytes = t->score_count * 28;
  for (i = 0; i < t->pattern_count; i++) {
    const uint8_t *r = t->patterns + 8 * i;
    unsigned next = be16(r), offset = be16(r + 2), score = be16(r + 4);
    size_t n = 0;
    if (next >= (unsigned)t->pattern_count || offset >= t->string_bytes ||
        score * 28u >= score_bytes)
      return 0;
    while (offset + n < t->string_bytes && t->strings[offset + n]) {
      if (t->strings[offset + n] >= 128)
        return 0;
      ++n;
    }
    if (offset + n == t->string_bytes)
      return 0;
    if (score) {
      if (!n)
        return 0;
      if (!r[6]) {
        size_t k;
        if (n > 7)
          return 0;
        for (k = 1; k < n; k++)
          if (t->strings[offset + k] < t->strings[offset + k - 1])
            return 0;
      } else {
        int link = i, steps = 0, row = sb(r[6]), column = sb(r[7]);
        if (row < 1 || row > 15 || column < 1 || column > 15)
          return 0;
        while ((link = be16(t->patterns + 8 * link)) != 0) {
          const uint8_t *relative;
          int cell;
          if (link >= t->pattern_count || ++steps >= t->pattern_count)
            return 0;
          relative = t->patterns + 8 * link;
          cell = 17 * (row + sb(relative[6])) + column + sb(relative[7]);
          if (cell < 0 || cell >= 544)
            return 0;
        }
      }
    }
  }
  return 1;
}
MavenTableResult maven_initialize_engine_tables(MavenEngineTables *t,
                                                const MavenTableResources *r) {
  unsigned i;
  uint32_t alphabet_offset;
  const uint8_t *g;
  if (!t || !r || !has(r->data, 2) || !has(r->zero, 2) ||
      !has(r->relocations, 2) || !has(r->preferences, 0x32e) ||
      !has(r->patterns, 8) || r->patterns.size % 8 || !has(r->strings, 1) ||
      !has(r->scores, 28) || r->scores.size % 28)
    return MAVEN_TABLES_INVALID;
  if (r->patterns.size > sizeof t->patterns ||
      r->strings.size > sizeof t->strings || r->scores.size > sizeof t->scores)
    return MAVEN_TABLES_CAPACITY;
  memset(t, 0, sizeof *t);
  if (maven_initialize_globals(t->globals, sizeof t->globals, r->data.data,
                               r->data.size, r->zero.data, r->zero.size,
                               r->relocations.data, r->relocations.size,
                               MAVEN_GLOBAL_BYTES))
    return MAVEN_TABLES_INVALID;
  g = t->globals + MAVEN_GLOBAL_BYTES;
  words(t->letter_values, g - 0x6bee, 128);
  words(t->small_pool, g - 0x6122, 17);
  words(t->q_with_u, g - 0x8fe, 5);
  words(t->q_without_u, g - 0x926, 35);
  memcpy(t->word_multipliers, g - 0x684e, 544);
  memcpy(t->letter_multipliers, g - 0x6a6e, 544);
  memcpy(t->classes, g - 0x428, 256);
  memcpy(t->distribution, g - 0x6aee, 128);
  memcpy(t->penalties, g - 0x976, 80);
  memcpy(t->vowels, g - 0xbca, 6);
  memcpy(t->q_query, g - 0x8e0, 2);
  memcpy(t->u_query, g - 0x8de, 3);
  alphabet_offset = be32(g - 0x662e);
  if (alphabet_offset > sizeof t->globals - 28)
    return MAVEN_TABLES_INVALID;
  memcpy(t->alphabet, t->globals + alphabet_offset, 28);
  memcpy(t->display_order, r->preferences.data + 0x312, 28);
  if (memcmp(t->alphabet, "?abcdefghijklmnopqrstuvwxyz", 28) ||
      memcmp(t->display_order, "abcdefghijklmnopqrstuvwxyz?", 28) ||
      t->vowels[5] || t->q_query[1] || t->u_query[2])
    return MAVEN_TABLES_INVALID;
  t->pattern_count = (int16_t)(r->patterns.size / 8);
  t->string_bytes = r->strings.size;
  t->score_count = r->scores.size / 28;
  memcpy(t->patterns, r->patterns.data, r->patterns.size);
  memcpy(t->strings, r->strings.data, r->strings.size);
  memcpy(t->scores, r->scores.data, r->scores.size);
  if (!pattern_valid(t) ||
      !maven_initialize_score_table(t->scores, r->scores.size) ||
      !score_words(t->opening, r->opening))
    return MAVEN_TABLES_INVALID;
  for (i = 0; i < 27; i++)
    if (!score_words(t->letter_scores[i], r->letters[i]))
      return MAVEN_TABLES_INVALID;
  for (i = 0; i < 8; i++)
    if (!score_words(t->composition_scores[i], r->composition[i]))
      return MAVEN_TABLES_INVALID;
  return MAVEN_TABLES_OK;
}
