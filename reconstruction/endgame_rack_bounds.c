#include "endgame_rack_bounds.h"
#include "rack_masks.h"
#include <string.h>
static int16_t word(int32_t value) {
    uint16_t x = (uint16_t)value;
    return x < 32768 ? (int16_t)x : (int16_t)((int32_t)x - 65536);
}
int16_t maven_bound_own_rack(void *context, int16_t own, int16_t *positive, int16_t *negative) {
    const MavenEndgameRackBounds *s = context;
    /* CODE39+0558/+0564 read offset 0x8ee = 127 * 18: depth zero.
       This is the opponent's full rack points, before any projected plays. */
    int16_t a = word(s->own_a[own][8]), other = word(s->other_a[127][0]);
    *positive = 0;
    *negative = word(s->own_error[own][8]);
    return word((a ? -a : other) + other + word(s->own_b[own][8]));
}
int16_t maven_bound_paired_racks_base(const MavenEndgameRackBounds *s, int16_t own, int16_t other,
                                      int16_t *positive, int16_t *negative) {
    const uint16_t *a = s->own_a[own], *b = s->own_b[own], *error = s->own_error[own];
    const uint16_t *oa = s->other_a[other], *ob = s->other_b[other], *oe = s->other_error[other];
    int16_t value =
        word(word(b[8]) - word(ob[8]) - word(a[8]) + (oa[8] ? word(oa[8]) : -word(a[8])));
    int depth;
    *positive = word(oe[8]);
    *negative = word(error[8]);
    for (depth = 7; depth > 0; --depth) {
        if (!oa[depth]) {
            int16_t trial = word(word(b[depth]) - word(ob[depth]) - 2 * word(a[depth]));
            if (value > trial) {
                value = trial;
                *positive = word(oe[depth]);
                *negative = word(error[depth]);
            }
        }
        if (!a[depth]) {
            int16_t trial = word(word(b[depth]) - word(ob[depth - 1]) + 2 * word(oa[depth - 1]));
            if (value < trial) {
                value = trial;
                *positive = word(oe[depth - 1]);
                *negative = word(error[depth]);
            }
        }
    }
    return value;
}
int16_t maven_bound_paired_racks(void *context, int16_t own, int16_t other, int16_t *positive,
                                 int16_t *negative) {
    const MavenEndgameRackBounds *s = context;
    int16_t value = maven_bound_paired_racks_base(s, own, other, positive, negative);
    if (word(2 * word(s->other_a[other][0]) + word(s->other_b[other][8])) ==
        word(s->other_error[other][8]))
        *positive = word(2 * word(s->other_a[other][0]) + word(s->own_b[own][8]) - value);
    return value;
}

static int64_t signed_long(uint32_t value) {
    return value <= INT32_MAX ? value : (int64_t)value - INT64_C(4294967296);
}
unsigned maven_prepare_endgame_rack_bounds(uint16_t a[128][9], uint16_t b[128][9],
                                           uint16_t error[128][9], const uint8_t *rack,
                                           const uint16_t *canonical, unsigned count,
                                           const uint16_t points[128], const uint32_t best[128],
                                           const uint32_t second[128], void (*diagnostic)(void *),
                                           void *user) {
    uint16_t masks[128];
    unsigned selected = 0, i, j, depth = 1;
    int changed = 1;
    uint16_t padding = (uint16_t)(128u - (1u << strlen((const char *)rack)));
    for (i = 0; i < count; ++i)
        if ((canonical[i] & padding) == padding)
            masks[selected++] = canonical[i];
    for (i = 0; i < selected; ++i) {
        unsigned m = masks[i];
        a[m][0] = points[m];
        b[m][0] = error[m][0] = 0;
    }
    while (changed) {
        if (depth >= 9) {
            diagnostic(user);
            return depth;
        }
        changed = 0;
        for (i = 0; i < selected; ++i) {
            unsigned m = masks[i];
            uint32_t incumbent;
            b[m][depth] = b[m][depth - 1];
            error[m][depth] = error[m][depth - 1];
            a[m][depth] = a[m][depth - 1];
            incumbent = (uint32_t)(int32_t)word(b[m][depth]);
            if (a[m][depth])
                incumbent -= 24u + (uint32_t)(2 * (int32_t)word(a[m][depth]));
            for (j = i; j < selected; ++j) {
                unsigned n = masks[j], remaining;
                uint32_t raw, objective;
                if ((m | n) != m || !best[n])
                    continue;
                remaining = maven_canonical_mask_difference((uint16_t)m, (uint16_t)n, rack,
                                                            diagnostic, user) |
                            padding;
                raw = (uint32_t)(int32_t)word(b[remaining][depth - 1]) + best[n];
                objective = raw;
                if (a[remaining][depth - 1])
                    objective -= 24u + (uint32_t)(2 * (int32_t)word(a[remaining][depth - 1]));
                if (signed_long(objective) > signed_long(incumbent)) {
                    int16_t previous_error = word(error[remaining][depth - 1]);
                    error[m][depth] = (uint16_t)(previous_error > signed_long(second[n])
                                                     ? (uint32_t)(int32_t)previous_error
                                                     : second[n]);
                    a[m][depth] = a[remaining][depth - 1];
                    b[m][depth] = (uint16_t)raw;
                    incumbent = objective;
                }
            }
            if (a[m][depth] != a[m][depth - 1] || b[m][depth] != b[m][depth - 1] ||
                error[m][depth] != error[m][depth - 1])
                changed = 1;
        }
        ++depth;
    }
    for (i = 0; i < selected; ++i)
        for (j = depth; j < 9; ++j) {
            unsigned m = masks[i];
            a[m][j] = a[m][j - 1];
            b[m][j] = b[m][j - 1];
            error[m][j] = error[m][j - 1];
        }
    return depth - 1;
}

void maven_prepare_endgame_mask_scores(uint32_t best[128], uint32_t second[128],
                                       const uint8_t *rack, const uint16_t *canonical,
                                       unsigned count, const uint16_t points[128],
                                       const uint16_t letter_values[128],
                                       const uint16_t occurrences[128][8],
                                       void (*diagnostic)(void *), void *user) {
    unsigned i;
    uint16_t padding = (uint16_t)(128u - (1u << strlen((const char *)rack)));
    for (i = 0; i < count; ++i) {
        unsigned mask = canonical[i], complement;
        if ((mask & padding) != padding)
            continue;
        complement =
            maven_canonical_mask_difference(127, (uint16_t)mask, rack, diagnostic, user) | padding;
        if (mask >= complement) {
            uint32_t swap = best[mask];
            best[mask] = best[complement];
            best[complement] = swap;
            swap = second[mask];
            second[mask] = second[complement];
            second[complement] = swap;
        }
    }
    if (strchr((const char *)rack, '?')) {
        unsigned blanks = 0;
        const uint8_t *tile = rack;
        for (; *tile; ++tile)
            if (*tile == '?')
                ++blanks;
        for (i = 0; i < count; ++i) {
            unsigned mask = canonical[i], position;
            uint8_t counts[128] = {0};
            for (position = 0; rack[position]; ++position)
                if (mask & (1u << position))
                    ++counts[rack[position]];
            if (counts['?'] < blanks)
                for (position = 0; rack[position]; ++position) {
                    unsigned letter = rack[position], replacement;
                    uint32_t candidate;
                    if (!(mask & (1u << position)) || letter == '?' || !counts[letter])
                        continue;
                    /* Visit the last SELECTED occurrence, as the emitted rack does. */
                    {
                        unsigned later;
                        int another = 0;
                        for (later = position + 1; rack[later] == letter; ++later)
                            if (mask & (1u << later))
                                another = 1;
                        if (another)
                            continue;
                    }
                    replacement = (mask & occurrences[letter][counts[letter] - 1]) |
                                  ((~occurrences['?'][counts['?']]) & 127u);
                    candidate = best[mask] - (uint32_t)(int32_t)word(letter_values[letter]);
                    if (signed_long(candidate) > signed_long(best[replacement]))
                        best[replacement] = candidate;
                }
        }
    }
    for (i = 0; i < count; ++i) {
        unsigned mask = canonical[i];
        uint32_t term = !second[mask] && best[mask]
                            ? (uint32_t)(int32_t)word(2 * word(points[mask]))
                            : 0u - second[mask];
        second[mask] = best[mask] + term;
        if (signed_long(second[mask]) < 0)
            diagnostic(user);
    }
}

void maven_endgame_local_score_corrections(const MavenEndgameRackBounds *s, uint8_t kept_mask,
                                           int16_t move_score, const uint8_t *rack,
                                           const uint16_t *masks, unsigned mask_count,
                                           const uint32_t best[128], int16_t first_depth,
                                           int16_t second_depth, int32_t *lower,
                                           int32_t *propagation, uint16_t *selected,
                                           void (*diagnostic)(void *), void *user) {
    uint16_t padding = (uint16_t)(128u - (1u << strlen((const char *)rack)));
    uint16_t played =
        maven_canonical_mask_difference(127, kept_mask, rack, diagnostic, user) | padding;
    unsigned i;
    *lower = *propagation = 0;
    for (i = 0; i < mask_count; ++i) {
        uint16_t mask = masks[i], remaining, combined;
        int16_t correction, sibling;
        if ((mask & padding) != padding || !best[mask])
            continue;
        remaining = maven_canonical_mask_difference(127, mask, rack, diagnostic, user) | padding;
        if ((remaining | kept_mask) != kept_mask && diagnostic)
            diagnostic(user);
        correction = word((uint16_t)(best[mask] - s->own_b[remaining][first_depth]));
        combined = maven_merge_mask_carry(played, remaining, padding);
        if (combined == 127 && word(s->own_a[remaining][first_depth]) > 0)
            correction = word((uint16_t)((uint16_t)correction + s->other_a[127][first_depth] +
                                         s->own_a[remaining][first_depth]));
        if (correction > *lower)
            *lower = correction;
        sibling =
            word((uint16_t)((uint16_t)move_score + best[mask] - s->own_b[combined][second_depth]));
        if (sibling > *propagation) {
            *selected = combined;
            *propagation = sibling;
        }
    }
}
