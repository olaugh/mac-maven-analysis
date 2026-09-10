#ifndef MAVEN_INDEX_FILE_H
#define MAVEN_INDEX_FILE_H
#include "error_context.h"
#include <stdint.h>
typedef const uint8_t *(*MavenReadWholeFile)(const void *name, short volume_reference,
                                             uint32_t *byte_count);
/* CODE 15 [4,0xd2). Valid-file contract: the original does not bounds-check
 * undersized files. Returns the loaded allocation; errors use the active
 * error frame. The loader owns allocation policy and the caller owns success. */
const uint8_t *maven_load_index_and_find_a(const void *name, uint32_t *record_index,
                                           MavenReadWholeFile read_file, MavenErrorContext *errors,
                                           const void *load_error);
#endif
