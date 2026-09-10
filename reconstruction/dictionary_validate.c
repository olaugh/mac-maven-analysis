#include "dictionary_validate.h"
#include <string.h>
static uint32_t be32(const uint8_t *p) {
  return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 |
         p[3];
}
static int section_valid(const uint8_t *p, uint32_t root) {
  uint32_t i, start = 257, previous = 0;
  if (be32(p) != 0x300 || be32(p + 256 * 4) != 0x200)
    return 0;
  for (i = 27; i < 256; i++)
    if (be32(p + 4 * i))
      return 0;
  if (memcmp(p + 4, p + 4 * root, 26 * 4))
    return 0;
  for (i = 257; i < root + 26; i++) {
    uint32_t node = be32(p + 4 * i), child = node >> 10, letter = node & 255;
    /* The shipped lexicon also contains three entries with trailing spaces. */
    if ((letter != ' ' && (letter < 'a' || letter > 'z')) ||
        letter <= previous || (node & 0x80000000u))
      return 0;
    /* A child may address a suffix of an earlier sibling group. */
    if (child && (child < 257 || child >= start))
      return 0;
    if (i >= root &&
        (letter != 'a' + i - root || !!(node & 512) != (i == root + 25)))
      return 0;
    if (i == root && start != root)
      return 0;
    if (node & 512) {
      start = i + 1;
      previous = 0;
    } else
      previous = letter;
  }
  return start == root + 26;
}
int maven_validate_dictionary(const uint8_t *data, size_t size,
                              MavenDictionarySection output[3]) {
  uint32_t roots[2];
  size_t lengths[2], offset;
  MavenDictionarySection result[3] = {{0, 0}};
  unsigned i;
  if (!data || !output || size < 12)
    return 0;
  roots[0] = be32(data + 4);
  roots[1] = be32(data + 8);
  for (i = 0; i < 2; i++) {
    if (roots[i] < 257 || roots[i] > 0x1fffff - 26)
      return 0;
    lengths[i] = ((size_t)roots[i] + 26) * 4;
  }
  if (lengths[0] > size - 12 || lengths[1] != size - 12 - lengths[0])
    return 0;
  offset = 12;
  for (i = 0; i < 2; i++) {
    if (!section_valid(data + offset, roots[i]))
      return 0;
    result[i] = (MavenDictionarySection){data + offset, (int32_t)roots[i]};
    offset += lengths[i];
  }
  memcpy(output, result, sizeof result);
  return 1;
}
