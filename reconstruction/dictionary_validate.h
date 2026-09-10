#ifndef MAVEN_DICTIONARY_VALIDATE_H
#define MAVEN_DICTIONARY_VALIDATE_H
#include "dictionary_lookup.h"
#include <stddef.h>
/* Validate the original two-section, ascending-DAG file layout before exposing
 * borrowed sections to the unchecked recovered walkers. Does not validate the
 * linguistic contents. Output remains unchanged on failure. */
int maven_validate_dictionary(const uint8_t *data, size_t size,
                              MavenDictionarySection output[3]);
#endif
