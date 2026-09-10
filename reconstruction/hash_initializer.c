#include "hash_initializer.h"
#include "rack_refill.h"
#include <string.h>
int maven_initialize_hash_table(uint32_t table[16], uint32_t *random_state) {
  uint32_t words[16], state;
  unsigned i;
  if (!table || !random_state)
    return 0;
  if (table[0])
    return 1;
  state = *random_state;
  for (i = 0; i < 16; i++)
    words[i] = maven_private_random_next(&state);
  if (!words[0])
    return 0;
  memcpy(table, words, sizeof words);
  *random_state = state;
  return 1;
}
