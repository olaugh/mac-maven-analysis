#include "late_pool_select.h"
#include <string.h>
static uint32_t read32(const uint8_t *p) {
    return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3];
}
static void write32(uint8_t *p, uint32_t x) {
    p[0] = (uint8_t)(x >> 24);
    p[1] = (uint8_t)(x >> 16);
    p[2] = (uint8_t)(x >> 8);
    p[3] = (uint8_t)x;
}
static void write16(uint8_t *p, uint16_t x) {
    p[0] = (uint8_t)(x >> 8);
    p[1] = (uint8_t)x;
}
static int32_t signed32(uint32_t x) {
    return x < UINT32_C(0x80000000) ? (int32_t)x : (int32_t)((int64_t)x - INT64_C(0x100000000));
}
static int32_t signed16(uint16_t x) { return x < 32768 ? x : (int32_t)x - 65536; }
uint32_t maven_late_remaining_leave(const MavenLatePool *s, const uint8_t used[128]) {
    uint32_t sum = 0;
    const uint8_t *letter;
    for (letter = s->distinct_letters; *letter; ++letter) {
        unsigned remaining = (uint8_t)(s->available[*letter] - used[*letter]);
        sum += (uint32_t)((int32_t)remaining * signed16(s->letter_leave[*letter]));
    }
    return sum;
}
static int matches(const uint8_t *record, const uint8_t *move, uint16_t tiles,
                   const uint8_t counts[4]) {
    return record[MAVEN_LATE_MOVE + 32] == move[32] && record[MAVEN_LATE_MOVE + 33] == move[33] &&
           record[MAVEN_LATE_USED_TILES] == tiles &&
           !memcmp(record + MAVEN_LATE_PRIORITY_COUNTS, counts, 4);
}
int16_t maven_late_match_reply(MavenLatePool *s, const uint8_t move[34], uint16_t tiles,
                               const uint8_t counts[4], uint32_t score) {
    int16_t slot = s->column_cache[move[33]];
    if (slot <= 0 || slot >= s->count || !matches(s->records[slot], move, tiles, counts)) {
        for (slot = 0; slot < s->count; ++slot)
            if (matches(s->records[slot], move, tiles, counts))
                break;
        if (slot == s->count)
            return -1;
        s->column_cache[move[33]] = slot;
    }
    if (signed32(score) > signed32(read32(s->records[slot] + MAVEN_LATE_SCORE))) {
        uint8_t saved[66];
        memcpy(saved, s->records[slot], 66);
        while (slot > 0 &&
               signed32(score) > signed32(read32(s->records[slot - 1] + MAVEN_LATE_SCORE))) {
            memcpy(s->records[slot], s->records[slot - 1], 66);
            --slot;
        }
        memcpy(s->records[slot], saved, 66);
        write32(s->records[slot] + MAVEN_LATE_SCORE, score);
    }
    return slot;
}
void maven_select_late_pool_reply(MavenLatePool *s, const uint8_t move[34], uint16_t tiles,
                                  const uint8_t used[128]) {
    uint32_t move_score = read32(move + 16), score, leave, going_out = 0;
    uint8_t priority[4], *record;
    unsigned i, remaining, target;
    int16_t slot;
    if (tiles > 7)
        return;
    if (s->count == 90 &&
        signed32(move_score + s->aggregate_leave_bits) <= signed32(s->cutoff_bits))
        return;
    remaining = s->unseen_count - tiles;
    target = remaining > 10 ? 7 : remaining > 3 ? remaining - 3 : 1;
    leave = maven_late_remaining_leave(s, used);
    score = move_score + (uint32_t)(signed32(leave * target) / (int32_t)remaining) +
            (uint32_t)signed16((uint16_t)(tiles * s->per_tile_adjustment));
    if (s->count == 90 && signed32(score) <= signed32(s->cutoff_bits))
        return;
    if (tiles == 7) {
        const uint8_t *letter;
        for (letter = s->distinct_letters; *letter; ++letter)
            going_out += (uint32_t)signed16((uint16_t)((s->available[*letter] - used[*letter]) *
                                                       signed16(s->letter_values[*letter])));
        going_out = going_out * 2 + move_score;
    }
    for (i = 0; i < 4; ++i)
        priority[i] = used[s->priority_letters[i]];
    slot = maven_late_match_reply(s, move, tiles, priority, score);
    if (slot < 0) {
        for (slot = 0; slot < s->count; ++slot)
            if (signed32(score) > signed32(read32(s->records[slot] + MAVEN_LATE_SCORE)))
                break;
        if (s->count < 90)
            ++s->count;
        memmove(s->records[slot + 1], s->records[slot], (s->count - 1 - slot) * 66u);
    } else if (signed32(score) < signed32(read32(s->records[slot] + MAVEN_LATE_SCORE)))
        return;
    record = s->records[slot];
    write16(record + MAVEN_LATE_REMAINING_LEAVE, (uint16_t)leave);
    write16(record + MAVEN_LATE_GOING_OUT_SCORE, (uint16_t)going_out);
    write32(record + MAVEN_LATE_SCORE, score);
    memcpy(record + MAVEN_LATE_MOVE, move, 34);
    record[MAVEN_LATE_USED_TILES] = (uint8_t)tiles;
    memcpy(record + MAVEN_LATE_PRIORITY_COUNTS, priority, 4);
    s->cutoff_bits = read32(s->records[s->count - 1] + MAVEN_LATE_SCORE);
}

static uint16_t read16(const uint8_t *p) { return (uint16_t)((uint16_t)p[0] << 8 | p[1]); }
uint16_t maven_late_reply_multiplicity(const MavenLatePool *s, const uint8_t move[34],
                                       uint16_t tiles, uint8_t used[128], const uint8_t *board,
                                       const uint16_t occurrences[128][8],
                                       const uint16_t choose[][8], uint8_t *bitmap, uint16_t tag) {
    uint16_t bonus = 0, weight = choose[s->available['?']][used['?']];
    unsigned i;
    if (signed32(read32(move + 16)) > 5000 && s->available['?'] != used['?']) {
        if (bitmap) {
            const uint8_t *cells = board + move[32] * 17 + move[33];
            for (i = 0; move[i]; ++i)
                if (!cells[i] && signed16(s->letter_values[move[i]]) < 800) {
                    uint8_t letter = move[i];
                    uint16_t mask = (uint16_t)(((uint16_t)~occurrences[letter][used[letter] - 1] |
                                                read16(move + 30)) &
                                               occurrences['?'][used['?']]);
                    if (bitmap[mask] != (uint8_t)tag) {
                        bonus = (uint16_t)(bonus + used[letter]);
                        bitmap[mask] = (uint8_t)tag;
                    }
                }
        } else if (tiles == 7)
            bonus = 7;
        else {
            bonus = tiles;
            for (i = 0; i < 4; ++i)
                bonus = (uint16_t)(bonus - used[s->priority_letters[i]]);
        }
    }
    for (i = 0; move[i]; ++i) {
        uint8_t letter = move[i], count = used[letter];
        if (!count)
            continue;
        used[letter] = 0;
        if (count != s->available[letter])
            weight = (uint16_t)(weight * choose[s->available[letter]][count]);
    }
    return (uint16_t)(weight + bonus);
}
void maven_merge_late_pool_reply(MavenLatePool *s, const uint8_t move[34], uint16_t tiles,
                                 uint8_t used[128], const uint8_t *board,
                                 const uint16_t occurrences[128][8], const uint16_t choose[][8],
                                 uint8_t *bitmap, const uint8_t inherited_priority[4]) {
    uint32_t move_score = read32(move + 16), score, leave, cutoff;
    unsigned i, remaining, target;
    uint8_t priority[4], *record;
    uint16_t kept = read16(move + 30);
    int16_t slot;
    if (tiles > 7)
        return;
    cutoff = read32(s->records[s->count - 1] + MAVEN_LATE_SCORE);
    if (signed32(move_score + s->aggregate_leave_bits) <= signed32(cutoff))
        return;
    remaining = s->unseen_count - tiles;
    target = remaining > 10 ? 7 : remaining > 3 ? remaining - 3 : 1;
    leave = maven_late_remaining_leave(s, used);
    score = move_score + (uint32_t)(signed32(leave * target) / (int32_t)remaining) +
            (uint32_t)signed16((uint16_t)(tiles * s->per_tile_adjustment));
    if (signed32(score) <= signed32(cutoff))
        return;
    for (i = 0; i < 4; ++i)
        priority[i] = used[s->priority_letters[i]];
    if (bitmap && bitmap[kept] != 255 && inherited_priority &&
        !memcmp(priority, inherited_priority, 4)) {
        slot = bitmap[kept];
        if (slot < s->count) {
            record = s->records[slot];
            if (record[MAVEN_LATE_MOVE + 32] == move[32] &&
                record[MAVEN_LATE_MOVE + 33] == move[33])
                return; /* Original diagnostics on inconsistent tiles or score. */
        }
    }
    slot = maven_late_match_reply(s, move, tiles, priority, score);
    if (slot < 0)
        return;
    record = s->records[slot];
    write16(record + MAVEN_LATE_MULTIPLICITY,
            (uint16_t)(read16(record + MAVEN_LATE_MULTIPLICITY) +
                       maven_late_reply_multiplicity(s, move, tiles, used, board, occurrences,
                                                     choose, bitmap, (uint16_t)slot)));
    write16(record + MAVEN_LATE_REQUIRED_MASK,
            (uint16_t)(read16(record + MAVEN_LATE_REQUIRED_MASK) & ~kept));
    if (bitmap)
        bitmap[kept] = (uint8_t)slot;
}

void maven_refine_late_pool_reply(MavenLatePool *s, const uint8_t move[34], uint16_t tiles,
                                  uint8_t used[128], const uint8_t *board,
                                  const uint16_t occurrences[128][8], const uint16_t choose[][8],
                                  uint8_t *bitmap) {
    uint32_t move_score = read32(move + 16), score, leave, cutoff, going_out = 0;
    unsigned i, remaining, target;
    uint8_t priority[4], *record;
    uint16_t kept = read16(move + 30), identifier;
    int16_t slot;
    if (tiles > 7)
        return;
    cutoff = read32(s->records[s->count - 1] + MAVEN_LATE_SCORE);
    if (signed32(move_score + s->aggregate_leave_bits) <= signed32(cutoff))
        return;
    remaining = s->unseen_count - tiles;
    target = remaining > 10 ? 7 : remaining > 3 ? remaining - 3 : 1;
    leave = maven_late_remaining_leave(s, used);
    score = move_score + (uint32_t)(signed32(leave * target) / (int32_t)remaining) +
            (uint32_t)signed16((uint16_t)(tiles * s->per_tile_adjustment));
    if (signed32(score) <= signed32(cutoff))
        return;
    for (i = 0; i < 4; ++i)
        priority[i] = used[s->priority_letters[i]];
    if (bitmap && bitmap[kept] != 255) {
        identifier = bitmap[kept];
        for (slot = 0; slot < s->count; ++slot) {
            record = s->records[slot];
            if (read32(record + 40) != identifier)
                continue;
            if (matches(record, move, tiles, priority)) {
                if (signed32(score) > signed32(read32(record + MAVEN_LATE_SCORE))) {
                    write32(record + MAVEN_LATE_SCORE, score);
                    memcpy(record + MAVEN_LATE_MOVE, move, 34);
                    write16(record + MAVEN_LATE_REMAINING_LEAVE, (uint16_t)leave);
                    write32(record + 40, identifier);
                }
                return;
            }
            break;
        }
    }
    if (tiles == 7) {
        const uint8_t *letter;
        for (letter = s->distinct_letters; *letter; ++letter)
            going_out += (uint32_t)signed16((uint16_t)((s->available[*letter] - used[*letter]) *
                                                       signed16(s->letter_values[*letter])));
        going_out = going_out * 2 + move_score;
    }
    slot = maven_late_match_reply(s, move, tiles, priority, score);
    if (slot >= 0) {
        record = s->records[slot];
        if (signed16(read16(record + MAVEN_LATE_GOING_OUT_SCORE)) < signed32(going_out))
            write16(record + MAVEN_LATE_GOING_OUT_SCORE, (uint16_t)going_out);
        identifier = read16(record + 42);
        if (score == read32(record + MAVEN_LATE_SCORE)) {
            memcpy(record + MAVEN_LATE_MOVE, move, 34);
            write16(record + MAVEN_LATE_REMAINING_LEAVE, (uint16_t)leave);
        }
        write16(record + MAVEN_LATE_MULTIPLICITY,
                (uint16_t)(read16(record + MAVEN_LATE_MULTIPLICITY) +
                           maven_late_reply_multiplicity(s, move, tiles, used, board, occurrences,
                                                         choose, bitmap, identifier)));
        write16(record + MAVEN_LATE_REQUIRED_MASK,
                (uint16_t)(read16(record + MAVEN_LATE_REQUIRED_MASK) & ~kept));
    } else {
        for (slot = 0; slot < s->count; ++slot)
            if (signed32(score) > signed32(read32(s->records[slot] + MAVEN_LATE_SCORE)))
                break;
        identifier = read16(s->records[s->count - 1] + 42);
        memmove(s->records[slot + 1], s->records[slot], (s->count - 1 - slot) * 66u);
        record = s->records[slot];
        write16(record + MAVEN_LATE_REMAINING_LEAVE, (uint16_t)leave);
        write32(record + MAVEN_LATE_SCORE, score);
        memcpy(record + MAVEN_LATE_MOVE, move, 34);
        record[MAVEN_LATE_USED_TILES] = (uint8_t)tiles;
        write16(record + MAVEN_LATE_GOING_OUT_SCORE, (uint16_t)going_out);
        memcpy(record + MAVEN_LATE_PRIORITY_COUNTS, priority, 4);
        write16(record + MAVEN_LATE_REQUIRED_MASK, (uint16_t)~kept);
        write16(record + MAVEN_LATE_MULTIPLICITY,
                maven_late_reply_multiplicity(s, move, tiles, used, board, occurrences, choose,
                                              bitmap, identifier));
    }
    if (bitmap) {
        write32(record + 40, identifier);
        bitmap[kept] = (uint8_t)identifier;
    }
}
