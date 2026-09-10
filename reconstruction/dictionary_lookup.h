#ifndef MAVEN_DICTIONARY_LOOKUP_H
#define MAVEN_DICTIONARY_LOOKUP_H
#include <stdint.h>

/* Native source view. Original descriptor: 32-bit pointer + 32-bit root index.
 * Records are serialized big-endian words; callers supply valid table storage.
 */
typedef struct MavenDictionarySection {
    const uint8_t *records;
    int32_t root_index;
} MavenDictionarySection;

uint32_t maven_section_contains(const MavenDictionarySection *section, const uint8_t *word);
int maven_counted_sections_contain(const MavenDictionarySection *sections, int16_t count,
                                   const uint8_t *word);
int maven_terminated_sections_contain(const MavenDictionarySection *sections, const uint8_t *word);
#endif
