#ifndef MAVEN_HISTORY_RECORDS_H
#define MAVEN_HISTORY_RECORDS_H
#include <stddef.h>
#include <stdint.h>
typedef struct { int8_t tag; uint16_t length; const uint8_t *payload; } MavenHistoryRecord;
typedef enum { MAVEN_HISTORY_OK, MAVEN_HISTORY_INVALID, MAVEN_HISTORY_CAPACITY } MavenHistoryResult;
/* CODE22 wire framing: BE16 tag, signed BE16 payload length, payload, repeated
 * to EOF. The reader retains only the tag's low byte. Unlike original I/O,
 * this port rejects truncation, negative lengths, empty histories and more
 * than32767 records before mutating output. Records borrow the input bytes.
 * On capacity failure, *count reports required records; descriptors remain
 * unchanged. Tag-specific validation belongs to the history interpreter. */
MavenHistoryResult maven_decode_history_records(const uint8_t *data,size_t length,
    MavenHistoryRecord *records,size_t capacity,size_t *count);
/* Bounded whole-file writer using CODE22 save framing and tag1 normalization.
 * Validates every descriptor before writing. On capacity failure *length is
 * the required size and output remains unchanged. Output must not overlap
 * any input payload or descriptors. Unlike original FSWrite, failures are
 * explicit and input payloads never change. */
MavenHistoryResult maven_encode_history_records(const MavenHistoryRecord *records,
    size_t count,uint8_t *output,size_t capacity,size_t *length);
#endif
