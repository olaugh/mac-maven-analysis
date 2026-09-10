#include "pattern_match.h"
#include <string.h>
static int16_t signed_word(uint16_t v) {
    return v < 32768 ? (int16_t)v : (int16_t)((int32_t)v - 65536);
}
static int word(const uint8_t *p) {
    return signed_word((uint16_t)((p[0] << 8) | p[1]));
}
static int byte(uint8_t v) {
    return v < 128 ? v : (int)v - 256;
}
static uint32_t long_bits(const uint8_t *p) {
    return ((uint32_t)p[0] << 24) | ((uint32_t)p[1] << 16) | ((uint32_t)p[2] << 8) | p[3];
}
static int32_t signed_long(uint32_t v) {
    return v <= INT32_MAX ? (int32_t)v : -1 - (int32_t)(UINT32_MAX - v);
}
MavenPatternMatchResult maven_match_patterns(const MavenPatternMatchInput *in, int16_t board_only,
                                             int16_t *record_ids, int16_t *weights) {
    MavenPatternMatchResult result = {0, 0};
    int id;
    for (id = 1; id < in->record_count; ++id) {
        const uint8_t *record = in->records + 8 * id, *letters, *score;
        int index = word(record + 4), row = byte(record[6]), col;
        uint32_t value;
        if (!index)
            continue;
        letters = in->strings + word(record + 2);
        score = in->score_records + 28 * index;
        value = long_bits(score + 24);
        if (!row) {
            size_t consumed = 0;
            int matched = 1;
            if (board_only)
                continue;
            while (letters[consumed]) {
                uint8_t letter = letters[consumed++], old = in->rack_counts[letter];
                --in->rack_counts[letter];
                if (!old) {
                    matched = 0;
                    break;
                }
            }
            while (consumed)
                ++in->rack_counts[letters[--consumed]];
            if (!matched)
                continue;
        } else {
            int link = id;
            uint8_t letter;
            size_t cell;
            col = byte(record[7]);
            if (col <= 0 || col >= 17)
                in->diagnostic(in->user);
            if (row <= 0 || row >= 17)
                in->diagnostic(in->user);
            cell = (size_t)(17 * row + col);
            letter = in->board[cell];
            if (!letter || !strchr((const char *)letters, letter))
                continue;
            while ((link = word(in->records + 8 * link)) != 0) {
                const uint8_t *relative = in->records + 8 * link;
                if (in->board[17 * (row + byte(relative[6])) + col + byte(relative[7])])
                    break;
            }
            if (link)
                continue;
            if (!in->values[cell]) {
                if (signed_long(value) < 0) {
                    int16_t doubled = signed_word((uint16_t)(in->letter_values[letter] * 2u));
                    value += (uint32_t)(int32_t)doubled;
                    if (signed_long(value) > 0)
                        value = 0;
                } else {
                    value -= (uint32_t)((int32_t)signed_word(in->letter_values[letter]) * 2);
                    if (signed_long(value) < 0)
                        value = 0;
                }
            } else if (letter == 'q' && strlen((const char *)letters) > 1) {
                value = (uint32_t)(signed_long(value) / 2);
            }
        }
        if (record_ids)
            record_ids[result.count] = (int16_t)id;
        if (weights)
            weights[result.count] = signed_word((uint16_t)value);
        ++result.count;
        result.total_bits += value;
    }
    if (record_ids)
        record_ids[result.count] = 0;
    if (weights)
        weights[result.count] = 0;
    return result;
}
