#!/usr/bin/env python3
"""Construct a separate tag0 test position; no original save or guest memory is modified."""
import gzip,hashlib,json,struct
from pathlib import Path
root=Path(__file__).resolve().parents[1];source=root/'analysis/toolchain/late-search-live.json.gz';j=json.loads(gzip.decompress(source.read_bytes()));finish=json.loads((root/'analysis/toolchain/late-search-finish-live.json').read_text());board=bytearray.fromhex(j['initial']['board']);values=struct.unpack('>544H',bytes.fromhex(j['initial']['values']));assert board[14*17+6]==ord('g');assert board[7*17+7]==ord('q');assert values[8*17+6]==values[9*17+5]==0
# ALANG -> ALAND is in the original dictionary. Freed real G replaces the
# blank G in ALIENAGE/GOS; that blank now represents the Q in QUOTA. This
# exchanges one unseen D for one unseen Q while preserving all word geometry.
board[14*17+6]=ord('d');payload=bytearray(board[:272]);payload.extend(bytes.fromhex(finish['rack0']));payload.extend(bytes.fromhex(finish['rack1']));payload.extend(struct.pack('>II',34400,27300));payload.extend(bytes([8,6,7,7]));assert len(payload)==300
raw=struct.pack('>HH',0,300)+payload
out=root/'../../media/maven/session/share/maven-search-unseenq';assert not out.exists();out.write_bytes(raw);out.with_name(out.name+'.idump').write_bytes((out.parent/'maven-search-late13.idump').read_bytes())
report=dict(scope=__doc__,name=out.name,source_capture_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),fixture_sha256=hashlib.sha256(raw).hexdigest(),changes=['ALANG at row14 col2 changed to ALAND by G->D at14,6','G at9,5 becomes real; Q at7,7 becomes blank; existing blank Q at8,6 retained'],expected_unseen='aaeeeeiknoqrt',synthetic_position=True,original_save_unchanged=True)
(root/'analysis/toolchain/late-q-fixture.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
