from pathlib import Path
import subprocess
import tempfile
import unittest

class RackRefillTests(unittest.TestCase):
    def test_callback_order_small_bag_and_generator(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "rack_refill.h"
#include <assert.h>
#include <string.h>
static char calls[64];static unsigned n,t;
static uint32_t random_value(void *u){(void)u;calls[n++]='p';return 1;}
static int16_t toolbox(void *u){(void)u;calls[n++]='q';return -2;}
static uint32_t ticks(void *u){(void)u;calls[n++]='t';return 100+t++;}
int main(void){uint8_t board[544],bag[32]="abcdefghi",rack[8]="abcdef";uint32_t seed;
 MavenRefillOps ops={0,random_value,toolbox,ticks};unsigned i;
 memset(board,0x55,sizeof board);
 /* One shuffle then one draw: unsigned(-1)%9=3, draw(99)%9=0. */
 maven_refill_rack_from_bag(rack,bag,9,board,999,&ops);
 assert(!strcmp((char *)rack,"abcdefa")&&!strcmp(calls,"tpqtpq"));
 assert(bag[0]=='d'&&bag[3]=='i');
 for(i=0;i<544;i++)assert(board[i]==(i<17?0:0x55));
 /* Threshold equals 8-6: no tick read, caller-provided stack word used. */
 strcpy((char *)rack,"abcdef");strcpy((char *)bag,"xy");memset(calls,0,sizeof calls);n=0;
 maven_refill_rack_from_bag(rack,bag,2,board,2,&ops);
 assert(!strcmp((char *)rack,"abcdefy")&&!strcmp(calls,"pq"));
 strcpy((char *)rack,"abcdef");strcpy((char *)bag,"xy");n=0;memset(calls,0,sizeof calls);
 maven_refill_rack_from_bag(rack,bag,2,board,1,&ops);
 assert(!strcmp((char *)rack,"abcdefx"));
 /* Empty bag consumes no randomness; still clears row zero. */
 n=0;memset(board,0x55,sizeof board);
 maven_refill_rack_from_bag(rack,bag,0,board,0,&ops);assert(!n&&!board[0]&&board[17]==0x55);
 seed=0;assert(maven_private_random_next(&seed)==0);
 seed=1;assert(maven_private_random_next(&seed)==0x40000000);
 assert(maven_private_random_next(&seed)==0x20000000);
 seed=0x11;assert(maven_private_random_next(&seed)==8);
 seed=0xffffffff;assert(maven_private_random_next(&seed)==0x7fffffff);
 return 0;}
'''
        with tempfile.TemporaryDirectory() as temp:
            src=Path(temp)/'test.c';src.write_text(source);exe=Path(temp)/'test'
            subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-I',str(root/'reconstruction'),str(src),str(root/'reconstruction/rack_refill.c'),'-o',str(exe)],check=True)
            subprocess.run([str(exe)],check=True,timeout=10)
