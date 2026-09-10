#ifndef MAVEN_LATE_SEARCH_BUDGET_H
#define MAVEN_LATE_SEARCH_BUDGET_H
#include <stdint.h>
/* CODE36[0x1842,0x1886): CPU-calibrated workload gate, NOT a memory check.
 * Original six-by-nine BE table begins at A5-0x89a, covering unseen8..16 and
 * all six legal partitions of up to two physical blanks between the racks.
 * Supply decoded words and the second CODE9+242 loop-count measurement;
 * CODE9+ee discards its first measurement. calibration must be nonzero.
 * own_blanks+unseen_blanks<=2 and unseen_total in8..16 are required.
 * force bypasses this gate in the caller before calibration or table access.
 * Natural and controlled-input original gate captures are in analysis/toolchain.
 */
unsigned maven_late_workload_row(unsigned own_blanks, unsigned unseen_blanks);
uint32_t maven_late_estimated_work(const uint16_t table[6][9], unsigned own_blanks,
                                  unsigned unseen_blanks, unsigned unseen_total,
                                  uint32_t calibration);
/* Original unsigned BLS admits exactly1700. Higher estimates use CODE28
 * heuristic search at CODE36+1886..1896 instead of late pool construction. */
int maven_late_estimate_exceeds_budget(uint32_t estimate);
/* Validated decision: -1 means missing/invalid inputs, 0 admits late search,
 * 1 selects heuristic fallback. Force bypasses table/calibration access.
 * A calibration is the result of original CODE9+ee, not host elapsed time. */
int maven_late_search_decision(const uint16_t table[6][9], unsigned own_blanks,
                               unsigned unseen_blanks, unsigned unseen_total,
                               uint32_t calibration, int force, uint32_t *estimate);
#endif
