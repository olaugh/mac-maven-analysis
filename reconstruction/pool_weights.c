#include "pool_weights.h"
#include <stddef.h>

void maven_prepare_pool_weights(MavenPoolWeights *state, const uint8_t counts[128],
                                const uint8_t *alphabet, uint16_t occurrences[128][8],
                                uint8_t distinct[28], uint16_t cache[48]) {
    unsigned repeated = 0, present = 0, i;
    state->unique_mask = state->total = 0;
    for (; *alphabet; ++alphabet) {
        uint8_t letter = *alphabet;
        if (!counts[letter])
            continue;
        distinct[present++] = letter;
        state->total += counts[letter];
        if (counts[letter] == 1)
            state->unique_mask |= (uint16_t)~occurrences[letter][0];
        else
            state->multiple_letters[repeated++] = letter;
    }
    distinct[present] = 0;
    state->multiple_letters[repeated] = 0;
    for (i = 0; i < state->total; ++i) {
        cache[i] = UINT16_MAX;
        occurrences[123 + i / 8][i % 8] = UINT16_MAX;
    }
}

typedef struct {
    const uint8_t *counts;
    const uint16_t (*occurrences)[8], (*choose)[8];
    uint8_t selected[18];
} WeightRecursion;

static uint16_t selected_weight(const WeightRecursion *s, unsigned length) {
    unsigned first = 0, i;
    uint16_t weight = 1;
    for (i = 1; i <= length; ++i)
        if (i == length || s->selected[i] != s->selected[first]) {
            weight = (uint16_t)(weight * s->choose[s->counts[s->selected[first]]][i - first]);
            first = i;
        }
    return weight;
}

static uint16_t count_requirements(WeightRecursion *s, uint16_t mask, const uint8_t *letters,
                                   unsigned length, unsigned target) {
    unsigned i, pool = 0;
    uint16_t result = 0;
    uint8_t letter;
    if (length > target)
        return 0;
    if (length == target)
        return mask ? 0 : selected_weight(s, length);
    letter = *letters;
    if (!letter)
        return 0;
    if (!mask) {
        const uint8_t *p;
        for (p = letters; *p; ++p)
            pool += s->counts[*p];
        if (target - length > pool)
            return 0;
        return (uint16_t)(s->choose[pool][target - length] * selected_weight(s, length));
    }
    /* No later letter can satisfy an earlier outstanding physical position. */
    if (mask & (uint16_t)((uint16_t)~s->occurrences[letter][0] - 1u))
        return 0;
    for (i = 0; i <= s->counts[letter]; ++i) {
        result = (uint16_t)(result + count_requirements(s, mask, letters + 1, length + i, target));
        /* The original writes one unused extra selection after its last
         * recursive call. It cannot affect a returned weight. */
        if (i == s->counts[letter] || length + i >= target)
            break;
        mask &= s->occurrences[letter][i];
        s->selected[length + i] = letter;
    }
    return result;
}

uint16_t maven_count_pool_racks(const MavenPoolWeights *state, uint8_t counts[128],
                                uint16_t requirements, const uint16_t occurrences[128][8],
                                const uint16_t choose[][8]) {
    uint16_t unique = state->unique_mask & requirements, result;
    unsigned remaining = 7, pool;
    uint8_t letters[29];
    unsigned n = 0;
    const uint8_t *p;
    WeightRecursion recursion = {counts, occurrences, choose, {0}};
    while (unique) {
        if (!remaining)
            return 0; /* Invalid >7 required distinct tiles cannot form a rack. */
        --remaining;
        unique &= (uint16_t)(unique - 1u);
    }
    requirements &= (uint16_t)~state->unique_mask;
    pool = state->total + remaining - 7;
    if (!requirements)
        return choose[pool][remaining];
    counts['{'] = (uint8_t)pool;
    for (p = state->multiple_letters; *p; ++p)
        if (requirements & (uint16_t)~occurrences[*p][0]) {
            letters[n++] = *p;
            counts['{'] -= counts[*p];
        }
    letters[n++] = '{';
    letters[n] = 0;
    result = count_requirements(&recursion, requirements, letters, 0, remaining);
    counts['{'] = 0;
    return result;
}
