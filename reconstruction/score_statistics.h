#ifndef MAVEN_SCORE_STATISTICS_H
#define MAVEN_SCORE_STATISTICS_H
#include <stddef.h>
#include <stdint.h>
/* CODE35+16c recalculates +24 of a28-byte score resource record from two
 * Motorola80-bit accumulated moments and its signed32-bit sample count.
 * The original five-step Newton approximation and80-point threshold are
 * preserved. This implementation uses IEEE double intermediates; fixed
 * shipped resource outputs are differentially checked, not arbitrary SANE
 * bit patterns. Invalid/nonfinite/out-of-range input returns0 unchanged. */
int maven_initialize_score_record(uint8_t record[28]);
/* Validate and initialize a whole table. Output may be partially initialized
 * if a later record is invalid; callers use a private staging allocation. */
int maven_initialize_score_table(uint8_t *records, size_t length);
#endif
