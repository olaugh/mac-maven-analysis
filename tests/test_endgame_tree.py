from pathlib import Path
import subprocess
import tempfile
import unittest

class EndgameTreeTests(unittest.TestCase):
    def test_bounds_pruning_pool_passes_codec_and_hash(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''#include "endgame_tree.h"
#include <assert.h>
#include <stddef.h>
#include <string.h>
static void diagnostic(void *u){(void)u;assert(!"unexpected tree diagnostic");}
int main(void){MavenEndgameNode nodes[8];MavenEndgameTree t={nodes,8,0,0,diagnostic,0,0};uint16_t a,b,c;uint8_t board[544]={0},move[34]={0},expanded[34];uint32_t table[16];unsigned i;
 assert(sizeof(MavenEndgameNode)==32&&offsetof(MavenEndgameNode,position_hash)==12&&offsetof(MavenEndgameNode,mark)==30);
 maven_endgame_tree_reset(&t);a=maven_endgame_allocate_node(&t);b=maven_endgame_allocate_node(&t);c=maven_endgame_allocate_node(&t);assert(a==1&&b==2&&c==3);
 nodes[a].lower=2;nodes[a].upper=4;nodes[a].move_score=8;nodes[a].placed_tiles[0]='a';nodes[a].row=8;
 nodes[b].lower=-3;nodes[b].upper=-1;nodes[b].move_score=5;nodes[b].placed_tiles[0]='b';nodes[b].row=8;
 maven_endgame_prepend_child(&t,0,a);maven_endgame_prepend_child(&t,0,b);
 maven_endgame_recompute_bounds(&t,0);assert(nodes[0].lower==6&&nodes[0].upper==8&&maven_endgame_select_child(&t,0)==b);
 t.current=c;maven_endgame_prune(&t,0);assert(nodes[0].first_child==b&&nodes[b].next_sibling==0);
 maven_endgame_mark(&t,0,1);assert(nodes[0].mark&&nodes[b].mark&&!nodes[a].mark);t.free_head=0;maven_endgame_sweep(&t);maven_endgame_mark(&t,0,0);assert(t.free_head==7&&nodes[0].first_child==b);
 nodes[b].position_hash=123;assert(maven_endgame_find_hash(&t,0,123,0)==b);assert(maven_endgame_find_hash(&t,0,123,2)==UINT16_MAX);
 t.current=c;assert(maven_endgame_reuse_position(&t,123)==UINT16_MAX);assert(nodes[c].lower==-3&&nodes[c].upper==-1);
 nodes[b].upper=-3;assert(maven_endgame_reuse_position(&t,123)==b);
 maven_endgame_tree_reset(&t);t.current=0;nodes[0].lower=-20;nodes[0].upper=30;a=maven_endgame_add_pass(&t);assert(nodes[a].lower==-30&&nodes[a].upper==20&&nodes[a].kept_mask==127);
 board[8*17+3]='c';memcpy(move,"cat",4);move[19]=12;move[23]=77;move[27]=88;move[29]=1;move[31]=5;move[32]=8;move[33]=3;b=maven_endgame_add_move(&t,move,board,9,-7);assert(!strcmp((char *)nodes[b].placed_tiles,"at")&&nodes[b].move_score==12&&nodes[b].leave_tag==77&&nodes[b].adjustment_tag==88);
 memset(expanded,0x5a,sizeof expanded);maven_endgame_expand_move(expanded,&nodes[b],board);assert(!strcmp((char *)expanded,"cat")&&expanded[4]==0x5a&&expanded[18]==4&&expanded[19]==0xb0&&expanded[31]==5&&expanded[29]==1);
 for(i=0;i<16;++i)table[i]=100+i;{uint8_t bytes[]={255,1};uint32_t expected=((99u>>4)+table[99&15]+1);assert(maven_hash_bytes(bytes,2,table)==expected);}
 {MavenEndgameNode small[2];MavenEndgameTree full={small,2,0,1,diagnostic,0,0};maven_endgame_tree_reset(&full);a=maven_endgame_allocate_node(&full);maven_endgame_prepend_child(&full,0,a);assert(maven_endgame_allocate_node(&full)==0);}
 {MavenEndgameFrontier f;MavenEndgameNode many[100];MavenEndgameTree tree={many,100,0,0,diagnostic,0,0};maven_endgame_tree_reset(&tree);a=maven_endgame_allocate_node(&tree);b=maven_endgame_allocate_node(&tree);maven_endgame_prepend_child(&tree,0,b);maven_endgame_prepend_child(&tree,0,a);
 many[a].lower=1;many[a].upper=3;many[a].move_score=10;many[b].lower=2;many[b].upper=4;many[b].move_score=9;
 f=maven_endgame_choose_frontier(&tree,0);assert(f.optimistic==a&&f.guaranteed==a&&f.alternative==b&&f.next_frontier==a);
 f=maven_endgame_choose_frontier(&tree,a);assert(f.next_frontier==b);assert(maven_endgame_continue_search(&tree,&f,2,3,0,20));
 many[a].emptied_rack=1;assert(!maven_endgame_continue_search(&tree,&f,2,3,0,20));many[b].lower=1;assert(maven_endgame_continue_search(&tree,&f,2,3,0,20));assert(!maven_endgame_continue_search(&tree,&f,50,50,0,20));assert(!maven_endgame_continue_search(&tree,&f,2,3,20,20));}
 return 0;}
'''
        with tempfile.TemporaryDirectory() as tmp:
            src=Path(tmp)/'test.c';src.write_text(source);exe=Path(tmp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/endgame_tree.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
