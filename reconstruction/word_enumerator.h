#ifndef MAVEN_WORD_ENUMERATOR_H
#define MAVEN_WORD_ENUMERATOR_H
#include "dictionary_lookup.h"
#include <stddef.h>

/* Native representation of CODE 12's globals, not an overlay on guest memory.
 * Valid input uses ASCII indices 0..127 and fits the original 32-byte word
 * buffer. As in the original, malformed indices/overlong words are unchecked.
 */
typedef struct MavenWordEnumeration {
    const MavenDictionarySection *sections;
    int16_t current_section;
    int16_t available[128];
    int16_t blanks_used; /* Remaining/minimum blanks alias available/required_counts['?']. */
    int16_t minimum_length, maximum_length, result_count;
    const uint8_t *prefix, *suffix, *required_letters;
    int16_t suffix_length;
    int16_t required_counts[128], occurrences[128];
    uint8_t word[32];
    size_t length;
    /* Adapter for the original UI-event poll and append operation. The
     * original increments result_count only after these operations return.
     */
    void (*append_word)(void *user, const uint8_t *word);
    void *user;
} MavenWordEnumeration;

void maven_enumerate_section(MavenWordEnumeration *state);
#endif
