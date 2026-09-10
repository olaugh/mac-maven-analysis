#include "display_move_score.h"
#include <string.h>
static int16_t sb(uint8_t x){return x<128?x:(int16_t)x-256;}
static uint32_t sw(uint16_t x){return (uint32_t)(x<32768?(int32_t)x:(int32_t)x-65536);}
static void put32(uint8_t *p,uint32_t x){p[0]=(uint8_t)(x>>24);p[1]=(uint8_t)(x>>16);p[2]=(uint8_t)(x>>8);p[3]=(uint8_t)x;}
void maven_score_display_move(void *context,uint8_t move[34]){
 MavenDisplayMoveScore *d=context;MavenApplyState *a=d->application;
 MavenLetterPlacement *p=&a->placement;unsigned row=move[32],col=move[33],i;
 uint32_t main=0,cross=0,multiplier=1;
 memset(move+16,0,16);a->new_tiles=0;
 a->recorded_row[0]=a->recorded_row[1]=a->recorded_column[0]=a->recorded_column[1]=0;
 if(!row)return;
 for(i=0;move[i];i++,col++){
  unsigned cell=row*17+col;
  if(!p->board[cell]){
   uint8_t letter=move[i],display=row<16?d->display[row*17+col]:d->display[col*17+row-15];
   int16_t lm=sb(a->letter_multipliers[cell]),wm=sb(p->premium_codes[cell]);
   uint32_t value,scaled;
   ++a->new_tiles;multiplier*=(uint32_t)(int32_t)wm;
   if(d->classes[display]&128){unsigned slot=a->recorded_row[1]?0:1;
    a->recorded_row[slot]=(int16_t)row;a->recorded_column[slot]=(int16_t)col;letter='?';}
   value=p->letter_values[letter];scaled=sw((uint16_t)(lm*(int32_t)sw((uint16_t)value)));main+=scaled;
   if((row!=16&&p->board[(row-1)*17+col])||(row!=15&&p->board[(row+1)*17+col])){
    int r;uint32_t sum=scaled;
    for(r=(int)row-1;r!=0&&r!=15&&p->board[r*17+col];--r)sum+=sw(p->values[r*17+col]);
    for(r=(int)row+1;r!=31&&r!=16&&p->board[r*17+col];++r)sum+=sw(p->values[r*17+col]);
    cross+=sum*(uint32_t)(int32_t)wm;
   }
  }else if(p->values[cell])main+=sw(p->values[cell]);
 }
 if(multiplier!=1&&multiplier!=2&&multiplier!=3&&multiplier!=4&&multiplier!=9)p->diagnostic(p->user);
 cross+=main*multiplier;
 if(strlen((const char *)d->own_rack)==(size_t)a->new_tiles){
  if(a->new_tiles==7)cross+=5000;
  move[28]=0;move[29]=1;
 }
 put32(move+16,cross);
}
