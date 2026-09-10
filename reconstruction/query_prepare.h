#ifndef MAVEN_QUERY_PREPARE_H
#define MAVEN_QUERY_PREPARE_H
#include "word_enumerator.h"

/* Inputs are already-normalized ASCII strings, as produced by the original
 * field readers/normalizer. Required workspace holds up to 127 bytes + NUL.
 * This does not implement Toolbox text extraction or MacRoman case mapping.
 * Existing length limits and occurrence workspace are retained.
 */
void maven_prepare_word_query(MavenWordEnumeration *state, const uint8_t *rack,
                              const uint8_t *on_board, const uint8_t *prefix, const uint8_t *suffix,
                              int bingos, uint8_t required_workspace[128]);
#endif
