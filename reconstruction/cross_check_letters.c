#include "cross_check_letters.h"

static uint32_t read_node(const MavenDictionarySection *section, int32_t index) {
    const uint8_t *p = section->records + (ptrdiff_t)index * 4;
    return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3];
}
static int signed_byte(uint8_t value) { return value < 128 ? value : (int)value - 256; }
int32_t maven_prefix_children(const MavenDictionarySection *section, const uint8_t *prefix) {
    int32_t index = section->root_index;
    if (!*prefix)
        return index;
    for (;;) {
        uint32_t node = read_node(section, index);
        uint8_t letter = (uint8_t)node;
        if (letter == *prefix) {
            index = (int32_t)(node >> 10);
            if (node & UINT32_C(0x80000000))
                index -= INT32_C(0x400000);
            if (!*++prefix)
                return index;
            if (!index)
                return -1;
        } else {
            if ((node & 0x200) || signed_byte(*prefix) < signed_byte(letter))
                return -1;
            ++index;
        }
    }
}
size_t maven_cross_check_letters(const MavenDictionarySection *sections, const uint8_t *prefix,
                                 const uint8_t *suffix, const uint8_t *allowed, uint8_t *output) {
    uint8_t *next = output;
    const MavenDictionarySection *section;
    for (section = sections; section->root_index; ++section) {
        const uint8_t *letter = allowed;
        int32_t index = maven_prefix_children(section, prefix);
        uint32_t node;
        if (index <= 0 || !*letter)
            continue;
        node = read_node(section, index);
        while (*letter) {
            if (signed_byte(*letter) < signed_byte((uint8_t)node)) {
                ++letter;
                continue;
            }
            if (*letter == (uint8_t)node) {
                if (!*suffix) {
                    if (node & 0x100)
                        *next++ = (uint8_t)node;
                } else if (node >> 10) {
                    MavenDictionarySection descendants = {section->records, (int32_t)(node >> 10)};
                    if (maven_section_contains(&descendants, suffix))
                        *next++ = (uint8_t)node;
                }
                ++letter;
            }
            if (node & 0x200)
                break;
            node = read_node(section, ++index);
        }
    }
    *next = 0;
    return (size_t)(next - output);
}
