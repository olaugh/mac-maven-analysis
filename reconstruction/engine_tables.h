#ifndef MAVEN_ENGINE_TABLES_H
#define MAVEN_ENGINE_TABLES_H
#include <stddef.h>
#include <stdint.h>
#define MAVEN_GLOBAL_BYTES 28654
#define MAVEN_MAX_PATTERNS 4096
#define MAVEN_MAX_SCORE_RECORDS 4096
#define MAVEN_PATTERN_STRING_BYTES 65536
typedef struct {
  const uint8_t *data;
  size_t size;
} MavenBlob;
typedef struct {
  MavenBlob data, zero, relocations, preferences, patterns, strings, scores,
      opening;
  MavenBlob letters[27], composition[8];
} MavenTableResources;
typedef struct {
  uint8_t globals[MAVEN_GLOBAL_BYTES];
  uint16_t letter_values[128], small_pool[17], q_with_u[5], q_without_u[35];
  uint32_t opening[16], letter_scores[27][8], composition_scores[8][8];
  uint8_t word_multipliers[544], letter_multipliers[544], classes[256],
      distribution[128];
  uint8_t alphabet[28], display_order[28], vowels[6], q_query[2], u_query[3],
      penalties[80];
  uint8_t patterns[MAVEN_MAX_PATTERNS * 8], strings[MAVEN_PATTERN_STRING_BYTES],
      scores[MAVEN_MAX_SCORE_RECORDS * 28];
  int16_t pattern_count;
  size_t string_bytes, score_count;
} MavenEngineTables;
typedef enum {
  MAVEN_TABLES_OK,
  MAVEN_TABLES_INVALID,
  MAVEN_TABLES_CAPACITY
} MavenTableResult;
/* Initializes owned tables directly from original resources, including DATA/
 * ZERO/DREL globals and CODE35 score initialization. No captured pointers,
 * memory dumps or cache state are inputs. This version supports the recovered
 * 28654-byte Mac Maven globals layout. On failure staging output may be
 * partially written; publish only a successful result. */
MavenTableResult maven_initialize_engine_tables(MavenEngineTables *,
                                                const MavenTableResources *);
#endif
