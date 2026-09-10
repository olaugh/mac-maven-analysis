#include "apply_move.h"
#include "board_state.h"
#include "move_finalize.h"
#include "score_move.h"
#include <string.h>
static int16_t signed_word(uint16_t x) {
    return x < 32768 ? (int16_t)x : (int16_t)((int32_t)x - 65536);
}
void maven_apply_move_with_details(const uint8_t *move, uint8_t *rack, MavenApplyState *s,
                                    uint32_t bonus, MavenAppliedMove *details) {
    MavenLetterPlacement *p = &s->placement;
    int16_t undo_end = 1;
    p->undo[0] = move[32];
    if (details) details->special_score = 0;
    (void)maven_count_board_bytes(p->board);
    if (!move[32]) {
        const uint8_t *letter;
        s->row_zero_count = signed_word((uint16_t)((uint16_t)s->row_zero_count + 1));
        for (letter = move; *letter; ++letter)
            --p->counts[*letter];
        strcpy((char *)p->board, (const char *)move);
    } else {
        uint8_t copy[34], remaining[16];
        MavenScoreScan score;
        unsigned i;
        MavenScoreInput input = {
            p->board,        p->values,   p->letter_values, p->premium_codes, s->letter_multipliers,
            s->letter_class, s->alphabet, p->diagnostic,    p->user};
        s->row_zero_count = 0;
        memcpy(copy, move, sizeof copy);
        score = maven_score_move_with_bonus(copy, rack, remaining, &input, bonus);
        if (details) strcpy((char *)details->remaining, (const char *)remaining);
        s->new_tiles = score.new_tiles;
        for (i = 0; i < 2; ++i) {
            s->recorded_row[i] = score.zero_value_row[i];
            s->recorded_column[i] = score.zero_value_column[i];
        }
        for (i = 0; i < 4; ++i)
            copy[16 + i] = (uint8_t)(score.score_bits >> (24 - 8 * i));
        if (score.score_bits & UINT32_C(0x80000000))
            p->diagnostic(p->user);
        if (s->scored_move)
            s->scored_move(s->callback_user, copy);
        {
            MavenPlacementResult placed = maven_place_move_letters(move, p);
            undo_end = placed.undo_end;
            if (details) details->special_score = placed.special_score;
        }
        maven_clear_recorded_move_values(p->values, s->recorded_row[0], s->recorded_column[0],
                                         s->recorded_row[1], s->recorded_column[1]);
    }
    maven_finish_move_rack(p->undo, undo_end, rack, p->counts, s->alphabet, p->diagnostic, p->user);
}

void maven_apply_move_with_bonus(const uint8_t *move, uint8_t *rack, MavenApplyState *s,
                                 uint32_t bonus) {
    maven_apply_move_with_details(move, rack, s, bonus, 0);
}

void maven_apply_move_without_evaluation(const uint8_t *move, uint8_t *rack, MavenApplyState *s) {
    maven_apply_move_with_bonus(move, rack, s, 5000);
}
