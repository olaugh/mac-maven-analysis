from pathlib import Path
import subprocess,tempfile,unittest
class EndgameMoveCacheTests(unittest.TestCase):
    def test_two_replies_per_mask_and_placement_dedup(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''#include "endgame_move_cache.h"
#include <assert.h>
#include <string.h>
static void move(uint8_t *m,const char *word,unsigned score,unsigned mask,unsigned row,unsigned col){memset(m,0,34);strcpy((char *)m,word);m[19]=(uint8_t)score;m[31]=(uint8_t)mask;m[32]=(uint8_t)row;m[33]=(uint8_t)col;}
int main(void){MavenEndgameMoveCache c={0};MavenCandidateList rank={0};uint8_t m[34];int i,seen=0;
move(m,"cat",12,3,8,4);maven_cache_opponent_endgame_move(&c,&rank,m);assert(c.best[3]==12&&rank.count==1);
move(m,"cot",10,3,8,4);maven_cache_opponent_endgame_move(&c,&rank,m);assert(c.second[3]==10&&rank.count==1);
move(m,"cut",15,3,8,4);maven_cache_opponent_endgame_move(&c,&rank,m);assert(c.best[3]==15&&c.second[3]==12&&rank.count==1&&!strcmp((char *)rank.moves[0],"cut"));
move(m,"ox",14,3,9,4);maven_cache_opponent_endgame_move(&c,&rank,m);assert(c.best[3]==15&&c.second[3]==14&&rank.count==2);
move(m,"out",4,0,6,8);m[29]=1;maven_cache_opponent_endgame_move(&c,&rank,m);assert(m[23]==20&&rank.count==3&&!strcmp((char *)rank.moves[0],"out"));
/* A high-ranked third location is retained outside the two-per-mask cache. */
move(m,"at",13,3,7,8);maven_cache_opponent_endgame_move(&c,&rank,m);maven_link_reply_summaries(&c,&rank);assert(c.summary_count==4);
for(i=c.first;i>=0;i=c.replies[i].next){assert(c.replies[i].row);++seen;}assert(seen==4&&c.first==259);
assert(c.replies[7].identifier==0&&c.replies[6].identifier==1&&c.replies[0].identifier==2&&c.replies[259].identifier==3);
/* Own-score table keeps the second arrival when scores tie, independent of rank. */
memset(&c,0,sizeof c);memset(&rank,0,sizeof rank);move(m,"cat",12,7,8,4);maven_cache_own_endgame_move(&c,&rank,m);maven_cache_own_endgame_move(&c,&rank,m);assert(c.best[7]==12&&c.second[7]==12&&rank.count==2);
return 0;}
'''
        with tempfile.TemporaryDirectory() as tmp:
            p=Path(tmp)/'test.c';p.write_text(source);exe=Path(tmp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-I',str(root/'reconstruction'),str(p),str(root/'reconstruction/endgame_move_cache.c'),str(root/'reconstruction/candidate_ranking.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True)
