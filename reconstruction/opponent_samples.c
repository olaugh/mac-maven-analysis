#include "opponent_samples.h"
#include <stddef.h>
typedef struct {
    const uint8_t *counts;
    const uint16_t (*choose)[8];
    MavenOpponentSampleVisitor visit;
    void *user;
    uint8_t letters[128], rack[8];
} Enumeration;
static uint32_t sign_extend_word(uint16_t word) {
    return word < 32768 ? word : (uint32_t)((int32_t)word - 65536);
}
static int16_t enumerate(Enumeration *s, unsigned letter, unsigned length) {
    unsigned count, i;
    uint8_t tile = s->letters[letter];
    if (length == 7) {
        uint32_t weight = 1;
        unsigned start = 0;
        s->rack[7] = 0;
        for (i = 1; i <= 7; ++i)
            if (i == 7 || s->rack[i] != s->rack[start]) {
                weight *= sign_extend_word(s->choose[s->counts[s->rack[start]]][i - start]);
                start = i;
            }
        return s->visit(s->user, s->rack, weight) != 0;
    }
    if (!tile)
        return 0;
    count = s->counts[tile];
    for (i = 0; i <= count && length + i <= 7; ++i) {
        if (enumerate(s, letter + 1, length + i))
            return 1;
        if (length + i < 7)
            s->rack[length + i] = tile;
    }
    return 0;
}
int16_t maven_enumerate_opponent_samples(const uint8_t counts[128], const uint8_t *alphabet,
                                         const uint16_t choose[][8],
                                         MavenOpponentSampleVisitor visit, void *user) {
    Enumeration state = {0};
    unsigned n = 0;
    state.counts = counts;
    state.choose = choose;
    state.visit = visit;
    state.user = user;
    for (; *alphabet; ++alphabet)
        if (counts[*alphabet])
            state.letters[n++] = *alphabet;
    state.letters[n] = 0;
    return enumerate(&state, 0, 0);
}
