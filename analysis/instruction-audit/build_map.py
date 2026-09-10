#!/usr/bin/env python3
"""Index byte-verified original disassembly; association is not instruction proof."""
import hashlib,importlib.util,json,re
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
def main():
 spec=importlib.util.spec_from_file_location('inventory',ROOT/'scripts/reconstruction_inventory.py')
 inventory=importlib.util.module_from_spec(spec);spec.loader.exec_module(inventory)
 records=[];segments=[]
 for resource in sorted((ROOT/'resources/CODE').glob('*.bin'),key=lambda p:int(p.stem.split('_')[0])):
  rid=int(resource.stem.split('_')[0]);data=resource.read_bytes();listing=ROOT/f'analysis/toolchain/code{rid}-corrected.asm';count=mapped=0
  if listing.exists():
   for line_no,line in enumerate(listing.read_text().splitlines(),1):
    m=re.match(r'^([0-9a-f]{4}):\s+([0-9a-f]+)\s+(.*)$',line)
    if not m:continue
    off=int(m[1],16);raw=bytes.fromhex(m[2]);assert data[off:off+len(raw)]==raw,(rid,off)
    candidates=[u[3] for u in inventory.UNITS if u[0]==rid and u[1]<=off and off+len(raw)<=u[2]]
    records.append(dict(resource=rid,offset=off,hex_offset=f'0x{off:04x}',bytes=raw.hex(),disassembly=m[3],listing=str(listing.relative_to(ROOT)),listing_line=line_no,source_candidates=candidates,status='associated_range_not_instruction_audited' if candidates else 'unmapped'))
    count+=1;mapped+=bool(candidates)
  segments.append(dict(resource=rid,resource_bytes=len(data),sha256=hashlib.sha256(data).hexdigest(),corrected_listing_available=listing.exists(),decoded_records=count,associated_records=mapped))
 sources={u[3] for u in inventory.UNITS}
 report=dict(scope='Byte-verified disassembly records associated with existing module ranges. Not proof every instruction is implemented. Listings may contain data directives. Missing listings and uncovered bytes remain unaudited.',decoded_records=len(records),associated_records=sum(bool(r['source_candidates']) for r in records),source_sha256={p:hashlib.sha256((ROOT/'reconstruction'/p).read_bytes()).hexdigest() for p in sorted(sources)},resources=segments,records=records)
 (Path(__file__).parent/'source-map.json').write_text(json.dumps(report,indent=2)+'\n')
 print(json.dumps({k:report[k] for k in ['decoded_records','associated_records']}))
if __name__=='__main__':main()
