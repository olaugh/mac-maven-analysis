#include "display_board.h"
#include <string.h>
int maven_rebuild_display_board(const uint8_t display[289],uint8_t previous[289],
    int force,const uint8_t classes[128],const uint16_t letters[128],
    uint8_t board[544],uint16_t values[544]) {
    unsigned row,column;
    if(!display||!previous||!classes||!letters||!board||!values)return 0;
    for(row=1;row<16;row++)for(column=1;column<16;column++)
        if(display[row*17+column]>=128)return 0;
    memset(board,0,544);memset(values,0,544*sizeof *values);
    for(row=1;row<16;row++)for(column=1;column<16;column++){
        unsigned i=row*17+column,cross=(column+15)*17+row;
        uint8_t raw=display[i],tile;uint16_t value;
        if(!force&&raw!=previous[i])continue;
        previous[i]=raw;
        if(!raw)continue;
        tile=classes[raw]&0x40?(uint8_t)(raw^0x20):raw;
        value=classes[raw]&0x80?0:letters[tile];
        board[i]=board[cross]=tile;values[i]=values[cross]=value;
    }
    return 1;
}
