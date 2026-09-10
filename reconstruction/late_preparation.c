#include "late_preparation.h"
#include "rack_counts.h"
#include "undo_move.h"
#include <string.h>
static uint32_t read32(const uint8_t *p) {
    return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 | p[3];
}
static uint16_t read16(const uint8_t *p) { return (uint16_t)((uint16_t)p[0] << 8 | p[1]); }
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
void maven_prepare_late_pool_replies(MavenLatePreparation *s) {
    MavenLatePool *pool = s->pool;
    MavenApplyState *app = s->application;
    MavenLetterPlacement *placement = &app->placement;
    MavenMoveUndo undo = {placement->board,     placement->values,     placement->undo,
                          &app->row_zero_count, placement->diagnostic, placement->user};
    unsigned i;
    s->patterns.board = placement->board;
    s->patterns.values = placement->values;
    s->patterns.letter_values = placement->letter_values;
    s->patterns.rack_counts = placement->counts;
    for (i = 0; i < pool->count; ++i) {
        uint8_t *record = pool->records[i], *move = record + MAVEN_LATE_MOVE;
        uint32_t value;
        unsigned slot = i;
        record[8] = record[9] = 0;
        record[10] = move[32];
        record[11] = move[33];
        record[12] = (uint8_t)strlen((const char *)move);
        write16(record + MAVEN_LATE_MULTIPLICITY,
                (uint16_t)(read16(record + MAVEN_LATE_MULTIPLICITY) *
                           s->draw_multiplicity[record[MAVEN_LATE_USED_TILES]]));
        maven_apply_move_with_bonus(move, s->pool_rack, app, s->bingo_bonus);
        value = maven_match_patterns(&s->patterns, 1, NULL, NULL).total_bits;
        if (s->pattern_value)
            s->pattern_value(s->user, i, value);
        if (signed32(value) < 0)
            value -= 300;
        write32(record + 36, value);
        write32(record + MAVEN_LATE_SCORE, read32(record + MAVEN_LATE_SCORE) + value);
        maven_undo_move(s->pool_rack, &undo);
        maven_count_rack(placement->counts, app->alphabet, s->pool_rack);
        while (slot && signed32(read32(pool->records[slot] + MAVEN_LATE_SCORE)) >
                           signed32(read32(pool->records[slot - 1] + MAVEN_LATE_SCORE))) {
            uint8_t saved[66];
            memcpy(saved, pool->records[slot], 66);
            memcpy(pool->records[slot], pool->records[slot - 1], 66);
            memcpy(pool->records[slot - 1], saved, 66);
            --slot;
        }
    }
    for (i = 0; i < pool->count; ++i) {
        uint8_t *record = pool->records[i];
        uint16_t weight = read16(record + MAVEN_LATE_MULTIPLICITY);
        if (weight > s->total_weight)
            write16(record + MAVEN_LATE_MULTIPLICITY, s->total_weight);
        write32(record + MAVEN_LATE_SCORE,
                read32(record + MAVEN_LATE_SCORE) -
                    (uint32_t)signed16(
                        (uint16_t)(record[MAVEN_LATE_USED_TILES] * pool->per_tile_adjustment)));
        write32(record + MAVEN_LATE_NEXT,
                i + 1 < pool->count ? s->serialized_record_base + (i + 1) * 66 : 0);
        record[13] = (uint8_t)i;
    }
}
