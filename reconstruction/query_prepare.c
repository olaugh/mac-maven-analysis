/* CODE 12 preparation: counting portions of +0x0102..0x0242,
 * mode transform +0x001c..0x0058, merge +0x0242..0x029c, and core reset.
 * Toolbox getters, character normalization and UI clear calls are external.
 */
#include "query_prepare.h"
#include <string.h>

static void counts(int16_t out[128], const uint8_t *text) {
    memset(out, 0, 128 * sizeof *out);
    while (*text)
        ++out[*text++];
}

void maven_prepare_word_query(MavenWordEnumeration *state, const uint8_t *rack,
                              const uint8_t *on_board, const uint8_t *prefix, const uint8_t *suffix,
                              int bingos, uint8_t required_workspace[128]) {
    int16_t prefix_counts[128], suffix_counts[128];
    unsigned i;
    uint8_t *required = required_workspace;
    counts(state->available, rack);
    counts(state->required_counts, on_board);
    counts(prefix_counts, prefix);
    counts(suffix_counts, suffix);
    prefix_counts['?'] = suffix_counts['?'] = 0;

    if (bingos) {
        for (i = 0; i < 128; ++i) {
            if (state->available[i] || state->required_counts[i]) {
                if (i != '?')
                    *required++ = (uint8_t)i;
                if (state->available[i] > state->required_counts[i])
                    state->required_counts[i] = state->available[i];
                state->available[i] = 0;
            }
        }
        *required = 0;
        ++state->available['?'];
    } else {
        while (*on_board)
            *required++ = *on_board++;
        *required = 0;
    }
    for (i = 0; i < 128; ++i) {
        int16_t count = (int16_t)(state->available[i] + state->required_counts[i]);
        if (count < suffix_counts[i])
            count = suffix_counts[i];
        if (count < prefix_counts[i])
            count = prefix_counts[i];
        state->available[i] = count;
    }
    state->prefix = prefix;
    state->suffix = suffix;
    state->suffix_length = (int16_t)strlen((const char *)suffix);
    state->required_letters = required_workspace;
    state->length = 0;
    state->word[0] = 0;
    state->result_count = 0;
    state->blanks_used = 0;
}
