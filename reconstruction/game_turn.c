#include "game_turn.h"
#include "board_state.h"
#include "rack_counts.h"
#include "rack_masks.h"
#include "remaining_tiles.h"
#include "move_statistics.h"
#include <string.h>
int maven_commit_game_turn(MavenGameTurn *g,const uint8_t move[34],
    int16_t *ids,int16_t *weights,MavenAppliedMove *workspace){
 MavenMoveEvaluation *e=g->evaluation;MavenApplyState *a=e->application;
 unsigned side=g->selected_side;uint8_t payload[52]={0};
 uint32_t score=(uint32_t)move[16]<<24|(uint32_t)move[17]<<16|(uint32_t)move[18]<<8|move[19];
 if(side>1)return 0;
 e->rack=g->racks[side];
 maven_count_rack(a->placement.counts,a->alphabet,e->rack);
 maven_rack_from_counts(e->rack,a->placement.counts,a->alphabet);
 g->mask_count=maven_prepare_canonical_rack_masks(e->rack,a->placement.letter_values,
   g->canonical_masks,g->tile_points,g->occurrence_masks);
 memcpy(payload,move,34);payload[35]=(uint8_t)(side==0);
 strcpy((char *)payload+36,(const char *)g->racks[side]);
 strcpy((char *)payload+44,(const char *)g->racks[1-side]);
 if(g->append&&!g->append(g->history_user,2,payload,52))return 0;
 g->totals[side]+=score;
 if(side==0&&g->display_score){
  g->display_score->application=a;g->display_score->own_rack=g->racks[0];
  a->scored_move=maven_score_display_move;a->callback_user=g->display_score;
 }
 g->evaluation_result=maven_apply_evaluated_move(move,e,g->features,ids,weights,workspace);
 maven_add_move_statistics(g->features,g->statistics[side]);
 a->scored_move=0;a->callback_user=0;
 g->bag_length=maven_collect_remaining_tiles(g->bag,e->distribution,a->placement.board,
   a->placement.values,g->racks[0],g->racks[1],a->alphabet);
 maven_refill_rack_from_bag(e->rack,g->bag,g->bag_length,a->placement.board,
   g->initial_stack_ticks,&g->refill);
 if(side==0){
  maven_count_rack(a->placement.counts,a->alphabet,g->racks[0]);
  maven_rack_from_counts(g->racks[0],a->placement.counts,g->display_order);
 }
 g->selected_side=1-side;e->rack=g->racks[g->selected_side];
 g->phase=maven_game_end_check(g->racks[0],g->racks[1],a->row_zero_count,a->placement.board)?4:side==0?2:3;
 return 1;
}

static int16_t signed_word(uint16_t v){return v<32768?(int16_t)v:(int16_t)((int32_t)v-65536);}
static void put_long(uint8_t *p,uint32_t v){p[0]=(uint8_t)(v>>24);p[1]=(uint8_t)(v>>16);p[2]=(uint8_t)(v>>8);p[3]=(uint8_t)v;}
int maven_finish_game(MavenGameTurn *g){
 uint16_t points[2]={0,0};int16_t delta[2];unsigned side,i,selected=g->selected_side;int both;
 if(selected>1)return 0;
 for(side=0;side<2;side++){
  const uint8_t *p=g->racks[side];
  while(*p)points[side]=(uint16_t)(points[side]+g->evaluation->application->placement.letter_values[*p++]);
 }
 if(!g->racks[1][0]){delta[0]=signed_word(points[1]);delta[1]=signed_word((uint16_t)(2*points[0]));}
 else if(!g->racks[0][0]){delta[0]=signed_word((uint16_t)(2*points[1]));delta[1]=signed_word(points[0]);}
 else{delta[0]=signed_word((uint16_t)-points[0]);delta[1]=signed_word((uint16_t)-points[1]);}
 for(side=0;side<2;side++){g->totals[side]+=(uint32_t)(int32_t)delta[side];g->statistics[side][4]+=(uint32_t)(int32_t)delta[side];}
 /* With both racks present, CODE7 swaps selected before emitting records.
  * The delta follows the opposite selector, while each stored total still
  * belongs to the record's own rack. Preserve this odd history convention. */
 both=g->racks[0][0]&&g->racks[1][0];
 if(both)selected=1-selected;
 for(i=0;i<2;i++){
  uint8_t payload[18]={0};side=i?selected:1-selected;
  payload[1]=(uint8_t)(side==0);strcpy((char *)payload+2,(const char *)g->racks[side]);
  put_long(payload+10,(uint32_t)(int32_t)delta[both?side:1-side]);put_long(payload+14,g->totals[side]);
  if(g->append&&!g->append(g->history_user,3,payload,18))return 0;
 }
 g->racks[0][0]=0;
 maven_count_rack(g->evaluation->application->placement.counts,g->evaluation->application->alphabet,g->racks[0]);
 g->selected_side=2;g->evaluation->rack=0;g->phase=5;
 return 1;
}
