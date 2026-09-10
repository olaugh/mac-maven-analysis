#include "dictionary_lookup.h"
#include <stddef.h>

static uint32_t record_word(const uint8_t *bytes) {
    return (uint32_t)bytes[0] << 24 | (uint32_t)bytes[1] << 16 | (uint32_t)bytes[2] << 8 | bytes[3];
}

static int signed_byte(uint8_t value) {
    return value < 128 ? value : (int)value - 256;
}

/* CODE 15 [0x01c8,0x023e). The original returns bit 8 (256), not 1, on
 * acceptance. Its child extraction is ASR.L #10 and its letter ordering uses
 * signed byte comparison. Those details are retained even though ordinary
 * dictionary letters are ASCII and valid child indices are nonnegative.
 * The original has no malformed-table bounds or cycle checks.
 * Ten natural section-0 Word List calls match this compiled reconstruction,
 * including zero and 256 results; see dictionary-live-calls.json. This is
 * not exhaustive validation and does not cover live section-1 calls.
 * Resource +0x0232 contains a JSR A5+0x01a2 with no incoming edge from this
 * decoded routine. It is not assigned invented reachable behavior here.
 */
uint32_t maven_section_contains(const MavenDictionarySection *section, const uint8_t *word) {
    int32_t index = section->root_index;
    uint8_t letter = *word;
    for (;;) {
        uint32_t node = record_word(section->records + (ptrdiff_t)index * 4);
        uint8_t node_letter = (uint8_t)node;
        if (letter == node_letter) {
            letter = *++word;
            if (letter == 0)
                return node & UINT32_C(0x100);
            index = (int32_t)(node >> 10);
            if (node & UINT32_C(0x80000000))
                index -= INT32_C(0x400000); /* Portable arithmetic right shift. */
            if (index == 0)
                return 0;
        } else {
            if ((node & UINT32_C(0x200)) || signed_byte(letter) < signed_byte(node_letter))
                return 0;
            ++index;
        }
    }
}

/* CODE 15 [0x0198,0x01c8): explicitly counted section list. */
int maven_counted_sections_contain(const MavenDictionarySection *sections, int16_t count,
                                   const uint8_t *word) {
    int16_t i;
    for (i = 0; i < count; ++i)
        if (maven_section_contains(&sections[i], word))
            return 1;
    return 0;
}

/* CODE 15 [0x023e,0x0276): separate list terminated by a zero root index. */
int maven_terminated_sections_contain(const MavenDictionarySection *sections, const uint8_t *word) {
    const MavenDictionarySection *section;
    for (section = sections; section->root_index != 0; ++section)
        if (maven_section_contains(section, word))
            return 1;
    return 0;
}
