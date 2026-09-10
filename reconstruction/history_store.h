#ifndef MAVEN_HISTORY_STORE_H
#define MAVEN_HISTORY_STORE_H
#include "history_records.h"
typedef struct {
    MavenHistoryRecord *records;
    size_t count,record_capacity;
    uint8_t *bytes;
    size_t used,byte_capacity;
} MavenHistoryStore;
/* Caller owns both buffers. Operations never allocate and report insufficient
 * capacity before mutation. Load replaces the contents after validating the
 * complete wire. Payload/descriptor buffers must not overlap each other.
 * Appended payloads are copied, so temporary caller buffers are accepted. */
MavenHistoryResult maven_history_store_load(MavenHistoryStore *store,const uint8_t *wire,size_t length);
MavenHistoryResult maven_history_store_append(MavenHistoryStore *store,int8_t tag,const uint8_t *payload,size_t length);
/* CODE7+2ee snapshot followed by tag4, preserving existing future records.
 * Modern padding bytes are initialized to zero instead of leaking original
 * stack contents after rack NULs. Inputs are initialized ASCII engine state.
 * The last two occupied zero-value cells in rows0..15 are recorded. */
MavenHistoryResult maven_history_store_snapshot(MavenHistoryStore *store,
    const uint8_t board[544],const uint16_t values[544],const uint8_t *rack0,
    const uint8_t *rack1,const uint32_t totals[2]);
#endif
