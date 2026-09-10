#include "late_search_budget.h"
unsigned maven_late_workload_row(unsigned own_blanks, unsigned unseen_blanks) {
    return own_blanks + unseen_blanks + (own_blanks ? own_blanks + 1 : 0);
}
uint32_t maven_late_estimated_work(const uint16_t table[6][9], unsigned own_blanks,
                                  unsigned unseen_blanks, unsigned unseen_total,
                                  uint32_t calibration) {
    uint16_t bits = table[maven_late_workload_row(own_blanks, unseen_blanks)][unseen_total - 8];
    int32_t work = bits < 32768 ? (int32_t)bits : (int32_t)bits - 65536;
    /* MULS.W sign-extends the table word, then CODE1+124 divides the resulting
     * bit pattern as UNSIGNED32 by the calibration count. */
    return (uint32_t)(work * 8224) / calibration;
}
int maven_late_estimate_exceeds_budget(uint32_t estimate) { return estimate > 1700; }

int maven_late_search_decision(const uint16_t table[6][9], unsigned own_blanks,
                               unsigned unseen_blanks, unsigned unseen_total,
                               uint32_t calibration, int force, uint32_t *estimate) {
    if (force) {
        if (estimate) *estimate = 0;
        return 0;
    }
    if (!table || !calibration || unseen_total < 8 || unseen_total > 16 ||
        own_blanks > 2 || unseen_blanks > 2 || own_blanks + unseen_blanks > 2)
        return -1;
    uint32_t value = maven_late_estimated_work(table, own_blanks, unseen_blanks,
                                               unseen_total, calibration);
    if (estimate) *estimate = value;
    return maven_late_estimate_exceeds_budget(value);
}
