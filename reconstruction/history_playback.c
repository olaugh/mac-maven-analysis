#include "history_playback.h"
#include "history_snapshot.h"
#include "rack_counts.h"
#include <string.h>
static uint32_t read_long(const uint8_t *p){return (uint32_t)p[0]<<24|(uint32_t)p[1]<<16|(uint32_t)p[2]<<8|p[3];}
static int rack_valid(const uint8_t *p,const uint8_t *alphabet){
 unsigned i;for(i=0;i<8;i++){
  const uint8_t *a=alphabet;if(!p[i])return 1;
  while(*a&&*a!=p[i])++a;if(!*a)return 0;
 }return 0;
}
static int move_valid(const uint8_t *p,const uint8_t *board,const uint8_t *alphabet){
 uint8_t counts[128]={0};unsigned n=0,i,row=p[32],column=p[33],placed=0;
 if(!rack_valid(p+36,alphabet)||!rack_valid(p+44,alphabet))return 0;
 while(n<16&&p[n]){if(p[n]>=128)return 0;++n;}
 if(n==16)return 0;
 if(!row)return 1;
 if(row>30||column<1||column>15||n>16-column||!n)return 0;
 maven_count_rack(counts,alphabet,p+36);
 for(i=0;i<n;i++){
  uint8_t tile=p[i],old=board[row*17+column+i];
  if(old){if(old!=tile)return 0;continue;}
  if(++placed>7)return 0;
  if(counts[tile])--counts[tile];else if(counts['?'])--counts['?'];else return 0;
 }
 return 1;
}
MavenPlaybackResult maven_restore_history_index(MavenHistoryPlayback *s,size_t index){
 size_t base,i;MavenApplyState *a;
 if(!s||!(a=s->application)||!s->records||index>=s->count||!s->racks[0]||!s->racks[1]||
    !a->placement.board||!a->placement.values||!a->placement.counts||!a->alphabet||!s->display_order||!s->refill)
  return MAVEN_PLAYBACK_INVALID;
 base=index;
 while(s->records[base].tag!=0&&s->records[base].tag!=1){
  if(!base)return MAVEN_PLAYBACK_INVALID;--base;
 }
 for(i=base;i<=index;i++){
  const MavenHistoryRecord *r=&s->records[i];const uint8_t *p=r->payload;
  size_t required=r->tag==0?300:r->tag==1?22:r->tag==2?52:r->tag==3?18:0;
  if(r->tag<0||r->tag>4||r->length<required||(required&&!p))return MAVEN_PLAYBACK_INVALID;
  if(r->tag==0){
   uint8_t racks[2][8];memcpy(racks[0],s->racks[0],8);memcpy(racks[1],s->racks[1],8);
   if(!maven_restore_history_snapshot(p,r->length,a->placement.board,a->placement.values,racks,s->totals,&s->selected_side,a->placement.letter_values))return MAVEN_PLAYBACK_INVALID;
   memcpy(s->racks[0],racks[0],8);memcpy(s->racks[1],racks[1],8);
  }else if(r->tag==1){
   if(!rack_valid(p+6,a->alphabet)||!rack_valid(p+14,a->alphabet))return MAVEN_PLAYBACK_INVALID;
   memset(a->placement.board,0,544);memset(a->placement.values,0,1088);
   strcpy((char *)s->racks[0],(const char *)p+6);strcpy((char *)s->racks[1],(const char *)p+14);
   s->totals[0]=s->totals[1]=0;s->selected_side=p[2]||p[3]?0:1;
  }else if(r->tag==2){
   unsigned side=p[34]||p[35]?0:1;
   if(!move_valid(p,a->placement.board,a->alphabet))return MAVEN_PLAYBACK_INVALID;
   strcpy((char *)s->racks[1-side],(const char *)p+44);
   s->totals[side]+=read_long(p+16);strcpy((char *)s->racks[side],(const char *)p+36);
   maven_count_rack(a->placement.counts,a->alphabet,s->racks[side]);
   maven_apply_move_without_evaluation(p,s->racks[side],a);
   if(!s->refill(s->user,side))return MAVEN_PLAYBACK_REFILL_FAILED;
  }else if(r->tag==3){
   s->totals[p[0]||p[1]?0:1]=read_long(p+14);s->racks[0][0]=s->racks[1][0]=0;
  }
  s->restored_index=i;if(s->checkpoint)s->checkpoint(s->user,i,r->tag);
 }
 s->selected_side=0;
 /* CODE7+002c -> CODE21+0052/+0004 recounts and sorts the displayed rack. */
 maven_count_rack(a->placement.counts,a->alphabet,s->racks[0]);
 maven_rack_from_counts(s->racks[0],a->placement.counts,s->display_order);
 return MAVEN_PLAYBACK_OK;
}

MavenPlaybackResult maven_prepare_history_selection(MavenHistoryPlayback *s,size_t selected){
 const MavenHistoryRecord *r;const uint8_t *p;MavenApplyState *a;
 if(!s||!(a=s->application)||selected>=s->count||!s->records)return MAVEN_PLAYBACK_INVALID;
 r=&s->records[selected];p=r->payload;
 if(r->tag==2){
  uint32_t tmp;
  if(r->length<52||!p||!rack_valid(p+36,a->alphabet)||!rack_valid(p+44,a->alphabet))return MAVEN_PLAYBACK_INVALID;
  strcpy((char *)s->racks[0],(const char *)p+36);strcpy((char *)s->racks[1],(const char *)p+44);
  if(!p[34]&&!p[35]){tmp=s->totals[0];s->totals[0]=s->totals[1];s->totals[1]=tmp;}
  s->selected_side=0;
  maven_count_rack(a->placement.counts,a->alphabet,s->racks[0]);
  maven_rack_from_counts(s->racks[0],a->placement.counts,s->display_order);
 }else if(r->tag==3){
  s->racks[0][0]=s->racks[1][0]=0;s->selected_side=2;
  maven_count_rack(a->placement.counts,a->alphabet,s->racks[0]);
 }
 return MAVEN_PLAYBACK_OK;
}
