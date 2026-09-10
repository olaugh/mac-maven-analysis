#include "smart_quotes.h"

uint8_t maven_smart_quote(uint8_t character, int16_t selection_start, uint8_t previous,
                          const uint8_t classes[256]) {
    int opening;
    if (character != '"' && character != '\'')
        return character;
    opening = selection_start == 0 || (classes[previous] & 6) || previous == '(' ||
              previous == '[' || previous == '{' || previous == '<' || previous == 0xca ||
              (previous == 0xd2 && character == '\'') || (previous == 0xd4 && character == '"');
    if (character == '"')
        return opening ? 0xd2 : 0xd3;
    return opening ? 0xd4 : 0xd5;
}
