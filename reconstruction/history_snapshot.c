#include "history_snapshot.h"
#include <string.h>
static uint32_t read_long(const uint8_t *p) {
    return (uint32_t)p[0]<<24|(uint32_t)p[1]<<16|(uint32_t)p[2]<<8|p[3];
}
static int valid_rack(const uint8_t *p) {
    unsigned i;
    for(i=0;i<8;i++){if(!p[i])return 1;if(p[i]>=128)return 0;}
    return 0;
}
int maven_restore_history_snapshot(const uint8_t *p,size_t length,
    uint8_t board[544],uint16_t values[544],uint8_t racks[2][8],
    uint32_t totals[2],int *side,const uint16_t letters[128]) {
    unsigned i,row,column;
    if(!p||length<300||!board||!values||!racks||!totals||!side||!letters)return 0;
    for(i=0;i<272;i++)if(p[i]>=128)return 0;
    if(!valid_rack(p+272)||!valid_rack(p+280))return 0;
    for(i=296;i<300;i+=2)if(p[i]>15||p[i+1]>15)return 0;
    /* Existing border bytes participate in the original value rebuild. */
    for(row=16;row<32;row++)if(board[row*17]>=128||board[row*17+16]>=128)return 0;
    memcpy(board,p,272);memset(board,0,17);
    for(row=16;row<32;row++)
        for(column=1;column<16;column++)
            board[row*17+column]=board[column*17+row-15];
    memset(values,0,544*sizeof *values);
    for(i=0;i<544;i++)if(board[i])values[i]=letters[board[i]];
    for(i=296;i<300;i+=2){
        values[p[i]*17+p[i+1]]=0;
        values[(p[i+1]+16)*17+p[i]]=0;
    }
    strcpy((char *)racks[0],(const char *)p+272);
    strcpy((char *)racks[1],(const char *)p+280);
    totals[0]=read_long(p+288);totals[1]=read_long(p+292);*side=0;
    return 1;
}
