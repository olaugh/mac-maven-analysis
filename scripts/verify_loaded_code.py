"""Verify a loaded segment against source or an exact previously observed SANE rewrite.
No address, padding, opcode, or arbitrary-byte masking is permitted.
"""
import hashlib,json
from pathlib import Path

def verify_loaded_code(read,a5,rid,slot,entry):
    stub=read(a5+slot,6)
    assert stub[:2]==bytes.fromhex('4ef9'),(rid,stub.hex())
    base=int.from_bytes(stub[2:],'big')-entry
    source=Path(f'resources/CODE/{rid}_{rid}.bin').read_bytes()
    actual=read(base+4,len(source)-4);patched=bytearray(source)
    source_hash=hashlib.sha256(source).hexdigest()
    if rid==32:
        known=next(x for x in json.loads(Path('analysis/toolchain/floating-trap-rewrites-live.json').read_text())['resources'] if x['code_resource']==32)
        assert known['source_sha256']==source_hash
        for change in known['differences']:
            assert patched[change['offset']]==change['original']
            patched[change['offset']]=change['live']
    elif rid==35:
        known=json.loads(Path('analysis/toolchain/late-constants-live.json').read_text())['code35']
        assert known['source_sha256']==source_hash
        for change in known['differences']:
            offset=change['offset'];before=bytes.fromhex(change['source']);after=bytes.fromhex(change['runtime'])
            assert patched[offset:offset+len(before)]==before
            patched[offset:offset+len(before)]=after
    assert actual in (source[4:],bytes(patched[4:])),rid
    return base,dict(code_resource=rid,sha256=source_hash,runtime_body_sha256=hashlib.sha256(actual).hexdigest(),identity='source' if actual==source[4:] else 'exact_prior_SANE_rewrite_fingerprint')
