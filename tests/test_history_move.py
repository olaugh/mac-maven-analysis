from pathlib import Path
import subprocess
import tempfile
import unittest


class MoveHistoryTests(unittest.TestCase):
    def test_previous_state_order_and_wrapping_score(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "history_move.h"
#include <assert.h>
#include <string.h>
static MavenInitialHistoryState state;static uint8_t payload[52];static int stage,player;
static void previous(void *u,int16_t index){(void)u;assert(stage++==0 && index==32767);state.totals[0]=state.totals[1]=10;payload[0x22]=player?0:0x80;}
static void count(void *u,uint8_t *rack){(void)u;assert(stage++==1&&rack==state.racks[player]);assert(!strcmp((char *)rack,"abc"));assert(!strcmp((char *)state.racks[1-player],"xyz"));assert(state.totals[player]==8&&state.totals[1-player]==10);}
static void apply(void *u,const uint8_t *p,uint8_t *rack,int16_t evaluate){(void)u;assert(stage++==2&&p==payload&&rack==state.racks[player]&&!evaluate);rack[0]='z';}
static void refresh(void *u,uint8_t *rack){(void)u;assert(stage++==3&&rack==state.racks[player]&&rack[0]=='z');}
int main(void){MavenMoveHistoryOps ops={0,previous,count,apply,refresh};
 payload[16]=payload[17]=payload[18]=255;payload[19]=254;strcpy((char *)payload+36,"abc");strcpy((char *)payload+44,"xyz");
 for(player=0;player<2;player++){stage=0;maven_restore_move_history(payload,-32768,&state,&ops);assert(stage==4);}return 0;}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),
                            str(root/'reconstruction/history_move.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
