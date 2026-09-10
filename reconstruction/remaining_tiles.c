#include "remaining_tiles.h"
#include <string.h>
uint32_t maven_collect_remaining_tiles(uint8_t *output, const uint8_t distribution[128],
                                       const uint8_t board[544], const uint16_t values[544],
                                       const uint8_t *rack0, const uint8_t *rack1,
                                       const uint8_t *alphabet) {
    uint8_t counts[128];
    uint32_t length = 0;
    unsigned row, column;
    memcpy(counts, distribution, sizeof counts);
    for (row = 0; row < 16; ++row)
        for (column = 0; column < 16; ++column) {
            unsigned cell = row * 17 + column;
            uint8_t letter = board[cell];
            if (letter)
                --counts[values[cell] || row == 0 ? letter : '?'];
        }
    while (*rack1)
        --counts[*rack1++];
    while (*rack0)
        --counts[*rack0++];
    while (*alphabet) {
        uint8_t letter = *alphabet++;
        unsigned count = counts[letter];
        if (count < 128)
            while (count--)
                output[length++] = letter;
    }
    output[length] = 0;
    return length;
}

int16_t maven_count_unseen_tiles(uint8_t output[128], const uint8_t distribution[128],
                                 const uint8_t board[544], const uint16_t values[544],
                                 const uint8_t rack_counts[128], const uint8_t *alphabet) {
    unsigned cell;
    uint16_t total = 0;
    memcpy(output, distribution, 128);
    for (cell = 17; cell < 272; ++cell)
        if (board[cell])
            --output[values[cell] ? board[cell] : '?'];
    while (*alphabet) {
        uint8_t letter = *alphabet++;
        output[letter] = (uint8_t)(output[letter] - rack_counts[letter]);
        if (output[letter] >= 128)
            output[letter] = 0;
        total = (uint16_t)(total + output[letter]);
    }
    return total < 32768 ? (int16_t)total : (int16_t)((int32_t)total - 65536);
}
