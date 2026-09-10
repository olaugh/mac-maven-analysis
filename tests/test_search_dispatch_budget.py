"""Selector routing and calibration ownership; engine bodies are isolated stubs.
Original gate arithmetic is separately replayed from natural/controlled traces.
"""
from pathlib import Path
import subprocess
import tempfile
import unittest
ROOT = Path(__file__).resolve().parents[1]

class SearchBudgetRoutingTests(unittest.TestCase):
    def test_routes_and_rejects_missing_calibration(self):
        source = r'''
#include "search_dispatch.h"
#include <assert.h>
#include <string.h>
static int heuristic_calls, late_calls, calibrations;
static uint32_t calibration_value;static uint8_t *expected_workspace;
static uint32_t calibrate(void *u) { assert(u == &calibrations); ++calibrations; return calibration_value; }
void maven_search_heuristic_moves_shared(MavenHeuristicSearch *s,uint8_t workspace[64]) { assert(workspace==expected_workspace); ++heuristic_calls; s->result->moves[0][0] = 'h'; }
int maven_search_late_game_shared(MavenLateSearch *s,uint8_t workspace[64]) { assert(workspace==expected_workspace); ++late_calls; assert(!s->force); s->ranking.moves[0][0] = 'l'; return 1; }
unsigned maven_search_endgame_shared(MavenEndgameSearch *s,uint8_t workspace[64]) { (void)s;(void)workspace; assert(0); return 0; }
int main(void) {
    static MavenLateSearch late;
    uint8_t board[544] = {0}, counts[128] = {0}, distribution[128] = {0};
    uint16_t values[544] = {0}, workload[6][9] = {{0}};
    uint8_t own[8] = "a", other[8] = "aaaaaaa", alphabet[] = "a";
    MavenApplyState app = {0}; MavenLeaveTable leaves = {0};
    MavenMoveEvaluation evaluation = {0}; MavenCandidateList ranking = {0};
    MavenHeuristicSearch heuristic = {0}; MavenSearchDispatch selector = {0};
    app.placement.board=board; app.placement.values=values; app.placement.counts=counts; app.alphabet=alphabet;
    distribution['a']=10; workload[0][1]=181;
    evaluation.application=&app; evaluation.distribution=distribution;
    heuristic.evaluation=&evaluation; heuristic.leaves=&leaves; heuristic.result=&ranking;
    late.application=&app; late.leaves=&leaves;
    selector.heuristic=&heuristic; selector.late=&late; selector.late_enabled=1;
    selector.late_workload=workload; selector.late_calibration=calibrate; selector.late_calibration_user=&calibrations;
    calibration_value=1;
    assert(maven_select_best_move(&selector,own,other));
    assert(selector.selected_kind==MAVEN_SEARCH_HEURISTIC && selector.selected_move[0]=='h');
    assert(selector.late_estimate==1488544 && heuristic_calls==1 && late_calls==0 && calibrations==1);
    calibration_value=4923651;
    assert(maven_select_best_move(&selector,own,other));
    assert(selector.selected_kind==MAVEN_SEARCH_LATE && selector.selected_move[0]=='l');
    assert(selector.late_estimate==0 && heuristic_calls==1 && late_calls==1 && calibrations==2);
    calibration_value=0;
    assert(!maven_select_best_move(&selector,own,other));
    assert(heuristic_calls==1 && late_calls==1 && calibrations==3);
    selector.late_calibration=0;
    assert(!maven_select_best_move(&selector,own,other));
    selector.late_enabled=0;
    assert(maven_select_best_move(&selector,own,other));
    assert(heuristic_calls==2 && late_calls==1 && calibrations==3);
    uint8_t workspace[64]={0};expected_workspace=workspace;
    assert(maven_select_best_move_shared(&selector,own,other,workspace));
    assert(heuristic_calls==3);
    selector.late_enabled=1;selector.late_calibration=calibrate;calibration_value=4923651;
    assert(maven_select_best_move_shared(&selector,own,other,workspace));assert(late_calls==2);
    uint32_t estimate=123;
    assert(maven_late_search_decision(0,99,99,99,0,1,&estimate)==0 && estimate==0);
    estimate=123;
    assert(maven_late_search_decision(workload,0,0,7,1,0,&estimate)==-1 && estimate==123);
    assert(maven_late_search_decision(workload,2,1,9,1,0,&estimate)==-1);
    assert(maven_late_search_decision(workload,0,0,9,0,0,&estimate)==-1);
    return 0;
}
'''
        with tempfile.TemporaryDirectory() as tmp:
            p = Path(tmp); (p/'probe.c').write_text(source)
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-fsanitize=address,undefined',
                '-I'+str(ROOT/'reconstruction'),str(p/'probe.c'),
                *[str(ROOT/f'reconstruction/{s}.c') for s in
                  ['search_dispatch','search_policy','late_search_budget','rack_counts','remaining_tiles']],
                '-o',str(p/'probe')],check=True)
            subprocess.run([str(p/'probe')],check=True)
