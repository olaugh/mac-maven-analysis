"""Close an owned Maven trace and confirm its breakpoints are gone.

QEMU can emit an unsolicited stop packet on connection and removes breakpoint
state when a debugger disconnects. Thus a fresh z0 may legitimately report E22.
Never interpret a stop packet as a memory/remove reply, and verify the address
by insert/remove when confirming the already-absent case.
"""
from gdb_remote import Remote
from qmp_session import command


def cleanup_breakpoints(remote, addresses):
    command('stop')
    remote.close()
    fresh=Remote()
    def request(packet):
        fresh.command(packet,wait=False)
        while True:
            result=fresh.receive()
            if result.startswith('T') or (len(result)==3 and result.startswith('S')):
                continue
            return result
    results=[]
    try:
        assert request('m40800000,10')=='f1acad130000002a067c4efa00804efa'
        for address in addresses:
            first=request(f'z0,{address:x},2')
            if first!='OK':
                assert first=='E22',(hex(address),first)
                assert request(f'Z0,{address:x},2')=='OK'
                assert request(f'z0,{address:x},2')=='OK'
            results.append(dict(address=address,initial_remove=first,confirmed_absent=True))
    finally:
        fresh.close()
    return results
