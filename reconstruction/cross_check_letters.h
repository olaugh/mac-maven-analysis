#ifndef MAVEN_CROSS_CHECK_LETTERS_H
#define MAVEN_CROSS_CHECK_LETTERS_H
#include "dictionary_lookup.h"
#include <stddef.h>

/* CODE37[0x36c,0x3ce): child-list index after prefix, root for empty prefix,
 * -1 for failed traversal, zero for a matched prefix with no descendants.
 * Node child extraction preserves the original arithmetic right shift. */
int32_t maven_prefix_children(const MavenDictionarySection *section, const uint8_t *prefix);

/* CODE37[0x3ce,0x4da): letters that complete prefix + letter + suffix.
 * The original prefix/suffix occupy one board string separated by the empty
 * square's NUL; this portable interface exposes the two strings explicitly.
 * allowed must be an ascending unique ASCII letter string. Section list has a
 * zero-root terminator. Output concatenates matches in section/letter order,
 * including duplicates across sections; caller supplies sufficient capacity.
 * Returns number of bytes excluding the appended NUL. No OS/runtime effects. */
size_t maven_cross_check_letters(const MavenDictionarySection *sections, const uint8_t *prefix,
                                 const uint8_t *suffix, const uint8_t *allowed, uint8_t *output);
#endif
