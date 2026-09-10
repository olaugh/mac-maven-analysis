#include "premium_exposure.h"
static int byte(uint8_t v) {
    return v < 128 ? v : (int)v - 256;
}
static int premium(const MavenPremiumExposureInput *in, int cell) {
    return byte(in->word_multipliers[cell]) * byte(in->letter_multipliers[cell]);
}
static uint32_t subtract_matching(uint32_t total, const uint8_t *records, int letter, int direction,
                                  int multiplier) {
    int i;
    for (i = 0; i < 20; ++i) {
        const uint8_t *p = records + 4 * i;
        if ((p[1] != 0) == direction && p[0] == letter && p[2] == multiplier)
            total -= p[3];
    }
    return total;
}
uint32_t maven_adjacent_premium_penalty(const uint8_t *move, const MavenPremiumExposureInput *in) {
    uint32_t penalty = 0;
    int row = byte(move[32]), column = byte(move[33]);
    const uint8_t *letter;
    if (!row)
        return 0;
    for (letter = move; *letter; ++letter, ++column) {
        int cell = 17 * row + column, m;
        if (!(in->letter_class[*letter] & 128))
            in->diagnostic(in->user);
        if (row < 1 || row > 30 || column < 1 || column > 15)
            in->diagnostic(in->user);
        if (in->board[cell]) {
            if (in->board[cell] != *letter)
                in->diagnostic(in->user);
            continue;
        }
        if (row != 1 && row != 16 && !in->board[cell - 17]) {
            m = premium(in, cell - 17);
            if (m != 1 && (row == 2 || row == 17 || !in->board[cell - 34]) &&
                (row == 15 || row == 30 || !in->board[cell + 17]))
                penalty = subtract_matching(penalty, in->penalties, *letter, 0, m);
        }
        if (row != 15 && row != 30 && !in->board[cell + 17]) {
            m = premium(in, cell + 17);
            if (m != 1 && (row == 1 || row == 16 || !in->board[cell - 17]) &&
                (row == 14 || row == 29 || !in->board[cell + 34]))
                penalty = subtract_matching(penalty, in->penalties, *letter, 1, m);
        }
    }
    return penalty;
}
