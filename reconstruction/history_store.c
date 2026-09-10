#include "history_store.h"
#include <string.h>
static int valid(const MavenHistoryStore *s) {
  return s && s->records && s->bytes && s->count <= s->record_capacity &&
         s->count <= 32767 && s->used <= s->byte_capacity;
}
MavenHistoryResult maven_history_store_load(MavenHistoryStore *s,
                                            const uint8_t *wire,
                                            size_t length) {
  size_t n = 0, i, used = 0;
  MavenHistoryResult result;
  if (!valid(s))
    return MAVEN_HISTORY_INVALID;
  result = maven_decode_history_records(wire, length, 0, 0, &n);
  if (result != MAVEN_HISTORY_CAPACITY)
    return result;
  if (n > s->record_capacity || length - 4 * n > s->byte_capacity)
    return MAVEN_HISTORY_CAPACITY;
  result = maven_decode_history_records(wire, length, s->records,
                                        s->record_capacity, &n);
  if (result != MAVEN_HISTORY_OK)
    return result;
  /* Pack owned payloads, excluding wire headers. Forward copies also support
   * loading from the arena itself because every destination precedes its input.
   */
  for (i = 0; i < n; i++) {
    memmove(s->bytes + used, s->records[i].payload, s->records[i].length);
    s->records[i].payload = s->bytes + used;
    used += s->records[i].length;
  }
  s->used = used;
  s->count = n;
  return MAVEN_HISTORY_OK;
}
MavenHistoryResult maven_history_store_append(MavenHistoryStore *s, int8_t tag,
                                              const uint8_t *payload,
                                              size_t length) {
  if (!valid(s) || length > 32767 || (length && !payload))
    return MAVEN_HISTORY_INVALID;
  if (s->count == s->record_capacity || s->count == 32767 ||
      length > s->byte_capacity - s->used)
    return MAVEN_HISTORY_CAPACITY;
  if (length)
    memmove(s->bytes + s->used, payload, length);
  s->records[s->count++] =
      (MavenHistoryRecord){tag, (uint16_t)length, s->bytes + s->used};
  s->used += length;
  return MAVEN_HISTORY_OK;
}
static void put32(uint8_t *p, uint32_t x) {
  p[0] = (uint8_t)(x >> 24);
  p[1] = (uint8_t)(x >> 16);
  p[2] = (uint8_t)(x >> 8);
  p[3] = (uint8_t)x;
}
MavenHistoryResult
maven_history_store_snapshot(MavenHistoryStore *s, const uint8_t board[544],
                             const uint16_t values[544], const uint8_t *rack0,
                             const uint8_t *rack1, const uint32_t totals[2]) {
  uint8_t payload[300] = {0};
  size_t i, n0 = 0, n1 = 0;
  if (!valid(s) || !board || !values || !rack0 || !rack1 || !totals)
    return MAVEN_HISTORY_INVALID;
  while (n0 < 8 && rack0[n0]) {
    if (rack0[n0] >= 128)
      return MAVEN_HISTORY_INVALID;
    ++n0;
  }
  while (n1 < 8 && rack1[n1]) {
    if (rack1[n1] >= 128)
      return MAVEN_HISTORY_INVALID;
    ++n1;
  }
  if (n0 == 8 || n1 == 8)
    return MAVEN_HISTORY_INVALID;
  for (i = 0; i < 272; i++)
    if (board[i] >= 128)
      return MAVEN_HISTORY_INVALID;
  if (s->record_capacity - s->count < 2 || s->count > 32765 ||
      s->byte_capacity - s->used < 300)
    return MAVEN_HISTORY_CAPACITY;
  memcpy(payload, board, 272);
  memcpy(payload + 272, rack0, n0);
  memcpy(payload + 280, rack1, n1);
  put32(payload + 288, totals[0]);
  put32(payload + 292, totals[1]);
  for (i = 0; i < 272; i++)
    if (board[i] && !values[i]) {
      payload[298] = payload[296];
      payload[299] = payload[297];
      payload[296] = (uint8_t)(i / 17);
      payload[297] = (uint8_t)(i % 17);
    }
  (void)maven_history_store_append(s, 0, payload, 300);
  return maven_history_store_append(s, 4, 0, 0);
}
