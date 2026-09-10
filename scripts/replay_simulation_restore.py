#!/usr/bin/env python3
"""Compare position restoration with captured original exit states.

Ordinary Escape and controlled sample-limit captures retain separate evidence
labels. Native exception unwinding and additional signed boundaries are host tests.
"""
import argparse,json,struct,subprocess
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--capture',type=Path,default=Path('analysis/toolchain/simulation-cancel-live.json'));a=p.parse_args();j=json.loads(a.capture.read_text());assert j['complete']
before=next(e['state'] for e in j['events'] if e['kind']=='before_restore');after=next(e['state'] for e in j['events'] if e['kind']=='board_racks_restored')
if 'controlled_mutation' not in j:
 assert before['board']!=j['saved']['board'],'Escape fixture must restore an altered board'
else:
 assert [e['kind'] for e in j['events']]==['limit_reached','exception_caught','before_restore','board_racks_restored','leave_rebuilt','returned']
 mutation=j['controlled_mutation'];old=bytes.fromhex(j['initial']['config']);changed=bytes.fromhex(j['initial_after_mutation']['config'])
 assert old[:4].hex()==mutation['before'] and changed[:4].hex()==mutation['after']
 assert old[4:]==changed[4:] and changed[:4]==changed[66:70]
 assert bytes.fromhex(j['initial_after_mutation']['config'])[16:18]==b'\0\0'
assert j['initial']['depth']==after['depth']+1
assert before['pending_error']==before['cancel_error']
decl=[]
for phase,st in [('saved',j['saved']),('before',before),('after',after)]:
 for key in ['board','values','rack0','rack1']:
  b=bytes.fromhex(st[key]);values=struct.unpack('>544H',b) if key=='values' else b
  decl.append('static '+('uint16_t' if key=='values' else 'uint8_t')+' '+phase+'_'+key+'[]={'+','.join(map(str,values))+'};')
source='''#include "simulation_restore.h"
#include "error_context.h"
#include <string.h>
#include <stdint.h>
#include <stdio.h>
static MavenErrorContext errors;static MavenSimulationSnapshot saved;
static uint8_t board[544],rack0[8],rack1[8];static uint16_t values[544];static int side;
#define REQUIRE(x) do{if(!(x)){fprintf(stderr,"failed: %s\\n",#x);return 1;}}while(0)
'''+ '\n'.join(decl)+ '\nint main(void){\n'
source+=f'errors.depth={after["depth"]};\n'
source+='maven_save_simulation_position(&saved,saved_board,saved_values,saved_rack0,saved_rack1,0);memcpy(board,before_board,544);memcpy(values,before_values,sizeof values);memcpy(rack0,before_rack0,8);memcpy(rack1,before_rack1,8);side=1;\n'
source+='if(MAVEN_SAVE_ERROR_CONTEXT(&errors)==0)maven_raise_error(&errors,(const void *)(uintptr_t)'+str(before['cancel_error'])+'u);\n'
source+=f'REQUIRE(errors.depth=={after["depth"]});REQUIRE((uintptr_t)errors.pending_error=={before["cancel_error"]}u);\n'
source+='maven_restore_simulation_position(&saved,board,values,rack0,rack1,&side);REQUIRE(!memcmp(board,after_board,544));REQUIRE(!memcmp(values,after_values,sizeof values));REQUIRE(!memcmp(rack0,after_rack0,8));REQUIRE(!memcmp(rack1,after_rack1,8));REQUIRE(side==0);\n'
# Static CMP.L signed ordering and exhaustive bypass, not original boundary observations.
cases=[(0,1,0),(1,1,1),(2,1,1),(0xffffffff,0,0),(0,0xffffffff,1),(0x80000000,0x7fffffff,0),(0x7fffffff,0x80000000,1)]
for count,limit,result in cases:
 b=count.to_bytes(4,'big');source+='{uint8_t e[46]={0};'+''.join(f'e[{42+i}]={v};' for i,v in enumerate(b))+f'REQUIRE(maven_simulation_sample_limit_reached(e,{limit}u,0)=={result});REQUIRE(!maven_simulation_sample_limit_reached(e,{limit}u,1));'+'}\n'
if 'controlled_mutation' in j:
 source+='{uint8_t entries[46]={'+','.join(map(str,changed[24:70]))+'};REQUIRE(maven_simulation_sample_limit_reached(entries,'+str(int.from_bytes(changed[:4],'big'))+'u,0));}\n'
source+='return 0;}\n';Path('.build/simulation-restore-probe.c').write_text(source)
subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-Ireconstruction','.build/simulation-restore-probe.c','reconstruction/simulation_restore.c','reconstruction/error_context.c','-o','.build/simulation-restore-probe'],check=True)
subprocess.run(['.build/simulation-restore-probe'],check=True)
print(json.dumps(dict(scope=__doc__,exit_vehicle='controlled lowered sample limit' if 'controlled_mutation' in j else 'ordinary Escape',original_restored_fields=['board','values','rack0','rack1','selected_side'],original_depth_after=after['depth'],host_limit_cases=len(cases)*2,all_matched=True)))
