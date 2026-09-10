#!/usr/bin/env python3
"""One QMP command per invocation; ignore asynchronous events, check errors."""
import argparse
import json
import socket


def command(name, arguments=None, path='/tmp/maven-re-qmp.sock'):
    with socket.socket(socket.AF_UNIX) as sock:
        sock.settimeout(10)
        sock.connect(path)
        stream = sock.makefile('rwb', buffering=0)
        greeting = json.loads(stream.readline())
        # A GDB resume can race a newly accepted QMP connection. QEMU may
        # deliver that asynchronous event before the connection greeting.
        # Still require the real greeting; an event is never a command reply.
        while 'event' in greeting:
            greeting = json.loads(stream.readline())
        if 'QMP' not in greeting:
            raise RuntimeError(f'not a QMP greeting: {greeting}')
        for ident, cmd, args in [(1, 'qmp_capabilities', {}), (2, name, arguments or {})]:
            stream.write((json.dumps(dict(execute=cmd, arguments=args, id=ident)) + '\n').encode())
            while True:
                result = json.loads(stream.readline())
                if result.get('id') == ident:
                    if 'error' in result:
                        raise RuntimeError(result['error'])
                    break
        return result['return']


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('command')
    p.add_argument('arguments', nargs='?', default='{}')
    a = p.parse_args()
    print(json.dumps(command(a.command, json.loads(a.arguments)), indent=2))
