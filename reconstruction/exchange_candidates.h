#ifndef MAVEN_EXCHANGE_CANDIDATES_H
#define MAVEN_EXCHANGE_CANDIDATES_H
#include <stdint.h>
typedef struct {
    const uint8_t *rack; /* Original selected rack order for lookup calls. */
    const uint8_t *sorted_rack;
    const int16_t *canonical_masks;
    int16_t mask_count;
    const uint16_t *leave_values;
    int16_t leave_offset;
    int16_t unseen_total;
    int opening; /* Original center square is empty. */
    uint16_t opening_score_zero, opening_score_five;
    int16_t (*adjusted_letter_value)(void *, uint8_t letter);
    void (*candidate)(void *, const uint8_t move[34]);
    void (*diagnostic)(void *);
    void *user;
    uint16_t *retained_count; /* Optional original top-ten count, reduced to1. */
} MavenExchangeCandidates;

/* CODE32[0x1304,0x140a). Generate exchange/pass records for precomputed canonical
 * kept-rack masks. Valid seven-tile sorted rack and unseen_total>7 required.
 * Original adjusted lookup and leave tables are caller-supplied boundaries.
 * Score corrections wrap as signed words, including doubling before division.
 * The34-byte record is reused: bytes after the word's NUL can retain text from
 * earlier candidates. On return, a nonzero retained_count becomes1 while the
 * trailing ranking slots remain untouched. Static recovery pending tracing. */
void maven_generate_exchange_candidates(MavenExchangeCandidates *state);
#endif
