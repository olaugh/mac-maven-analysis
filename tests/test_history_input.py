"""Malformed-file boundaries and atomic rejection for the portable history input."""
import subprocess,tempfile,unittest
from pathlib import Path
class HistoryInput(unittest.TestCase):
 def test_truncation_capacity_and_snapshot_bounds(self):
  root=Path(__file__).resolve().parents[1]
  source=r'''
#include "history_records.h"
#include "history_snapshot.h"
#include "display_board.h"
#include <assert.h>
#include <string.h>
int main(void){
 uint8_t wire[]={0,1,0,2,0xaa,0xbb,0xff,0xfe,0,0},payload[300]={0};
 MavenHistoryRecord records[2],saved_records[2];size_t n=99,i;
 uint8_t board[544],racks[2][8];uint16_t values[544],letters[128]={0};
 uint32_t totals[2]={11,12};int side=7;
 uint8_t display[289]={0},previous[289]={0},classes[128]={0};
 memset(records,0x5a,sizeof records);memcpy(saved_records,records,sizeof records);
 assert(maven_decode_history_records(wire,sizeof wire,records,1,&n)==MAVEN_HISTORY_CAPACITY&&n==2);
 assert(!memcmp(records,saved_records,sizeof records));
 assert(maven_decode_history_records(wire,sizeof wire,records,2,&n)==MAVEN_HISTORY_OK);
 assert(records[0].tag==1&&records[0].length==2&&records[0].payload==wire+4);
 assert(records[1].tag==-2&&records[1].length==0&&records[1].payload==wire+10);
 memcpy(saved_records,records,sizeof records);
 for(i=1;i<6;i++){
  assert(maven_decode_history_records(wire,i,records,2,&n)==MAVEN_HISTORY_INVALID);
  assert(!memcmp(records,saved_records,sizeof records));
 }
 {
  uint8_t source[6]={1,2,3,4,0xaa,0xbb},output[16],saved_output[16];size_t size=0;
  MavenHistoryRecord r={1,6,source};
  memset(output,0x5a,sizeof output);memcpy(saved_output,output,sizeof output);
  assert(maven_encode_history_records(&r,1,output,9,&size)==MAVEN_HISTORY_CAPACITY&&size==10);
  assert(!memcmp(output,saved_output,sizeof output));
  assert(maven_encode_history_records(&r,1,output,sizeof output,&size)==MAVEN_HISTORY_OK);
  assert(size==10&&output[8]==0&&output[9]==0&&source[4]==0xaa&&source[5]==0xbb);
  memcpy(saved_output,output,sizeof output);r.length=32768;
  assert(maven_encode_history_records(&r,1,output,sizeof output,&size)==MAVEN_HISTORY_INVALID);
  assert(!memcmp(output,saved_output,sizeof output));r.length=2;
  assert(maven_encode_history_records(&r,1,output,sizeof output,&size)==MAVEN_HISTORY_INVALID);
 }
 wire[2]=128;
 assert(maven_decode_history_records(wire,sizeof wire,records,2,&n)==MAVEN_HISTORY_INVALID);
 memset(board,0,sizeof board);memset(values,0x3c,sizeof values);memset(racks,0x55,sizeof racks);
 for(i=0;i<300;i++)assert(!maven_restore_history_snapshot(payload,i,board,values,racks,totals,&side,letters));
 payload[299]=16;
 assert(!maven_restore_history_snapshot(payload,300,board,values,racks,totals,&side,letters));
 payload[299]=0;payload[20]=128;
 assert(!maven_restore_history_snapshot(payload,300,board,values,racks,totals,&side,letters));
 payload[20]=0;memset(payload+272,'a',8);
 assert(!maven_restore_history_snapshot(payload,300,board,values,racks,totals,&side,letters));
 assert(values[0]==0x3c3c&&racks[0][0]==0x55&&totals[0]==11&&side==7);
 display[18]='A';classes['A']=0xc0;letters['a']=100;
 assert(maven_rebuild_display_board(display,previous,0,classes,letters,board,values));
 assert(!board[18]&&!board[273]&&previous[18]==0);
 assert(maven_rebuild_display_board(display,previous,1,classes,letters,board,values));
 assert(board[18]=='a'&&board[273]=='a'&&!values[18]&&!values[273]&&previous[18]=='A');
 display[19]=128;
 assert(!maven_rebuild_display_board(display,previous,1,classes,letters,board,values));
 assert(board[18]=='a'&&previous[18]=='A'&&previous[19]==0);
 return 0;
}
'''
  with tempfile.TemporaryDirectory() as tmp:
   p=Path(tmp);(p/'test.c').write_text(source)
   subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-Ireconstruction',str(p/'test.c'),'reconstruction/history_records.c','reconstruction/history_snapshot.c','reconstruction/display_board.c','-o',str(p/'test')],cwd=root,check=True)
   subprocess.run([str(p/'test')],check=True)
