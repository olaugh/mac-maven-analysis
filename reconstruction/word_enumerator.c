/* CODE 12 [0x038e,0x0668): append guard, prefix walk, rack walk, suffix
 * check, and candidate constraints. Instruction-derived reconstruction;
 * Four natural enumerations match in emission order and restored core state:
 * see analysis/toolchain/word-enumerator-live-summary.json. This does not
 * reconstruct input parsing, UI storage/rendering or exceptional exits.
 */
#include "word_enumerator.h"

static uint32_t node_at(const MavenWordEnumeration *s, uint32_t index) {
    const uint8_t *p = s->sections[s->current_section].records + index * 4;
    return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3];
}

static int suffix_matches(const MavenWordEnumeration *s) {
    const uint8_t *pattern = s->suffix;
    const uint8_t *word;
    if (s->length < (size_t)s->suffix_length)
        return 0;
    word = s->word + s->length - s->suffix_length;
    while (*pattern) {
        if (*pattern != '?' && *pattern != *word)
            return 0;
        ++pattern;
        ++word;
    }
    return 1;
}

static int constraints_match(MavenWordEnumeration *s) {
    const uint8_t *p;
    int matches = 0;
    for (p = s->word; *p; ++p)
        ++s->occurrences[*p];
    if ((int16_t)s->length >= s->minimum_length && (int16_t)s->length <= s->maximum_length &&
        s->blanks_used >= s->required_counts['?']) {
        for (p = s->required_letters; *p; ++p)
            if (s->occurrences[*p] < s->required_counts[*p])
                break;
        matches = (*p == 0);
    }
    for (p = s->word; *p; ++p)
        s->occurrences[*p] = 0;
    return matches;
}

static void append_candidate(MavenWordEnumeration *s) {
    if (s->result_count < 1000) {
        s->append_word(s->user, s->word);
        ++s->result_count;
    }
}

static void walk_rack(MavenWordEnumeration *s, uint32_t index, uint32_t terminal);
static void walk_prefix(MavenWordEnumeration *s, uint32_t index, uint32_t terminal,
                        const uint8_t *pattern);

static void follow_letter(MavenWordEnumeration *s, uint32_t node, const uint8_t *remaining_prefix) {
    uint8_t letter = (uint8_t)node;
    int used_blank = 0;
    if (s->available[letter] > 0)
        --s->available[letter];
    else if (s->available['?'] > 0) {
        --s->available['?'];
        ++s->blanks_used;
        used_blank = 1;
    } else
        return;

    s->word[s->length++] = letter;
    /* Unlike the membership routine's ASR, both enumerators use LSR here. */
    if (remaining_prefix)
        walk_prefix(s, node >> 10, node & UINT32_C(0x100), remaining_prefix);
    else
        walk_rack(s, node >> 10, node & UINT32_C(0x100));

    s->word[s->length--] = 0;
    if (used_blank) {
        --s->blanks_used;
        ++s->available['?'];
    } else
        ++s->available[letter];
}

static void walk_rack(MavenWordEnumeration *s, uint32_t index, uint32_t terminal) {
    uint32_t node;
    if (terminal && suffix_matches(s) && constraints_match(s) &&
        !maven_counted_sections_contain(s->sections, s->current_section, s->word))
        append_candidate(s);
    if (!index || s->result_count >= 1000)
        return;
    do {
        node = node_at(s, index++);
        follow_letter(s, node, 0);
    } while (!(node & UINT32_C(0x200)));
}

static void walk_prefix(MavenWordEnumeration *s, uint32_t index, uint32_t terminal,
                        const uint8_t *pattern) {
    uint32_t node;
    if (s->result_count >= 1000)
        return;
    if (!*pattern) {
        walk_rack(s, index, terminal);
        return;
    }
    if (!index)
        return;
    do {
        node = node_at(s, index++);
        if (*pattern == '?' || *pattern == (uint8_t)node)
            follow_letter(s, node, pattern + 1);
    } while (!(node & UINT32_C(0x200)));
}

void maven_enumerate_section(MavenWordEnumeration *state) {
    walk_prefix(state, (uint32_t)state->sections[state->current_section].root_index, 0,
                state->prefix);
}
