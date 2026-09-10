/* Small research bridge: bounded file decode, snapshot load and display rebuild. */
#include "history_records.h"
#include "history_snapshot.h"
#include "display_board.h"
#include "history_playback.h"
#include "rack_refill.h"
#include "remaining_tiles.h"
#include <stddef.h>
#include <stdint.h>
void *memset(void *p,int value,size_t n){uint8_t *b=p;while(n--)*b++=(uint8_t)value;return p;}
void *memcpy(void *d,const void *s,size_t n){uint8_t *a=d;const uint8_t *b=s;while(n--)*a++=*b++;return d;}
size_t strlen(const char *s){size_t n=0;while(s[n])++n;return n;}
char *strcpy(char *d,const char *s){char *start=d;while((*d++=*s++)){}return start;}
static uint8_t wire[1048576],board[544],racks[2][8],display[289],previous[289],classes[128];
static uint16_t values[544],letters[128];
static uint32_t totals[2];
static MavenHistoryRecord records[1024];
static size_t count;
static int side;
static uint8_t display_order[28];
static uint8_t counts[128],undo[33],word_multipliers[544],letter_multipliers[544],alphabet[28],distribution[128];
static uint32_t random_events[4096][2],refill_ticks[1024];
static uint8_t trace[1024][2048];
static unsigned random_count,random_index,refill_count,refill_index,trace_count,trace_size,input_failed;
static uint32_t private_seed;
static MavenApplyState app;
static MavenHistoryPlayback playback;
void *maven_history_buffer(unsigned id){
 switch(id){case 0:return wire;case 1:return board;case 2:return values;case 3:return racks;
 case 4:return totals;case 5:return letters;case 6:return display;case 7:return previous;case 8:return classes;case 9:return counts;case 10:return undo;case 11:return word_multipliers;
 case 12:return letter_multipliers;case 13:return alphabet;case 14:return distribution;case 15:return random_events;
 case 16:return refill_ticks;case 17:return trace;case 18:return display_order;default:return 0;}
}
int maven_history_decode(unsigned length){
 size_t n=0;MavenHistoryResult result;
 count=0;if(length>sizeof wire)return MAVEN_HISTORY_CAPACITY;
 result=maven_decode_history_records(wire,length,records,1024,&n);
 if(result==MAVEN_HISTORY_OK)count=n;return result;
}
int maven_history_snapshot(unsigned index){
 if(index>=count||records[index].tag!=0)return 0;
 return maven_restore_history_snapshot(records[index].payload,records[index].length,board,values,racks,totals,&side,letters);
}
int maven_history_rebuild(int force){return maven_rebuild_display_board(display,previous,force,classes,letters,board,values);}
unsigned maven_history_count(void){return (unsigned)count;}
int maven_history_side(void){return side;}

static void put32(uint8_t **p,uint32_t v){*(*p)++=(uint8_t)(v>>24);*(*p)++=(uint8_t)(v>>16);*(*p)++=(uint8_t)(v>>8);*(*p)++=(uint8_t)v;}
static void record_state(void *u,size_t index,int tag){uint8_t *p;unsigned i;(void)u;
 if(trace_count>=1024){input_failed=1;return;}p=trace[trace_count++];
 put32(&p,(uint32_t)index);put32(&p,(uint32_t)tag);
 memcpy(p,board,544);p+=544;for(i=0;i<544;i++){*p++=(uint8_t)(values[i]>>8);*p++=(uint8_t)values[i];}
 memcpy(p,racks,16);p+=16;memcpy(p,counts,128);p+=128;memcpy(p,undo,33);p+=33;
 put32(&p,playback.totals[0]);put32(&p,playback.totals[1]);put32(&p,(uint32_t)playback.selected_side);
 put32(&p,(uint32_t)app.row_zero_count);put32(&p,(uint32_t)app.new_tiles);
 for(i=0;i<2;i++)put32(&p,(uint32_t)app.recorded_row[i]);for(i=0;i<2;i++)put32(&p,(uint32_t)app.recorded_column[i]);
 trace_size=(unsigned)(p-trace[trace_count-1]);
}
static uint32_t input(unsigned kind){uint32_t value;
 if(random_index>=random_count||random_count>4096){input_failed=1;return ++random_index;}
 if(random_events[random_index][0]!=kind)input_failed=1;
 value=random_events[random_index++][1];
 if(!kind){uint32_t computed=maven_private_random_next(&private_seed);if(computed!=value)input_failed=1;return computed;}
 return value;
}
static uint32_t next_private(void *u){(void)u;return input(0);}
static int16_t next_toolbox(void *u){uint16_t value;(void)u;value=(uint16_t)input(1);return value<32768?(int16_t)value:(int16_t)((int32_t)value-65536);}
static uint32_t next_ticks(void *u){(void)u;return input(2);}
static int refill(void *u,unsigned player){uint8_t bag[128];uint32_t length;MavenRefillOps ops={0,next_private,next_toolbox,next_ticks};(void)u;
 if(refill_index>=refill_count||refill_count>1024)return 0;
 length=maven_collect_remaining_tiles(bag,distribution,board,values,racks[0],racks[1],alphabet);
 maven_refill_rack_from_bag(racks[player],bag,length,board,refill_ticks[refill_index++],&ops);return !input_failed;
}
static void diagnostic(void *u){(void)u;input_failed=1;}
int maven_history_play(unsigned index){MavenPlaybackResult result;
 random_index=refill_index=trace_count=input_failed=0;
 app.placement=(MavenLetterPlacement){board,values,counts,letters,word_multipliers,undo,diagnostic,0};
 app.letter_multipliers=letter_multipliers;app.letter_class=classes;app.alphabet=alphabet;
 playback.display_order=display_order;playback.application=&app;playback.racks[0]=racks[0];playback.racks[1]=racks[1];playback.records=records;playback.count=count;
 playback.selected_side=side;playback.totals[0]=totals[0];playback.totals[1]=totals[1];playback.refill=refill;playback.checkpoint=record_state;
 result=maven_restore_history_index(&playback,index);side=playback.selected_side;totals[0]=playback.totals[0];totals[1]=playback.totals[1];return result;
}
void maven_history_set(unsigned id,uint32_t value){switch(id){
 case 0:random_count=value;break;case 1:refill_count=value;break;case 2:private_seed=value;break;
 case 3:app.row_zero_count=(int16_t)value;break;case 4:app.new_tiles=(int16_t)value;break;
 case 5:case 6:app.recorded_row[id-5]=(int16_t)value;break;case 7:case 8:app.recorded_column[id-7]=(int16_t)value;break;
 case 9:side=(int)value;break;default:input_failed=1;}}
uint32_t maven_history_get(unsigned id){switch(id){case 0:return random_index;case 1:return refill_index;case 2:return private_seed;
 case 3:return trace_count;case 4:return trace_size;case 5:return input_failed;default:return 0;}}
