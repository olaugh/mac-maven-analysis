#!/usr/bin/env python3
"""Minimal checksum-validated GDB remote client for the local QEMU session.

Commands follow the GDB remote protocol; no inferred register layout is used.
"""
import argparse
import socket


class Remote:
    def __init__(self, path='/tmp/maven-re-gdb.sock'):
        self.sock = socket.socket(socket.AF_UNIX)
        self.sock.settimeout(10)
        self.sock.connect(path)

    def close(self):
        self.sock.close()

    def receive(self):
        while True:
            marker = self.sock.recv(1)
            if not marker:
                raise EOFError('GDB disconnected before packet')
            if marker == b'$':
                break
        wire = bytearray()
        while True:
            c = self.sock.recv(1)
            if not c:
                raise EOFError('GDB disconnected')
            if c == b'#':
                break
            wire.extend(c)
        checksum = b''
        while len(checksum) < 2:
            chunk = self.sock.recv(2 - len(checksum))
            if not chunk:
                raise EOFError('GDB disconnected during checksum')
            checksum += chunk
        if sum(wire) % 256 != int(checksum, 16):
            self.sock.sendall(b'-')
            raise ValueError('GDB packet checksum mismatch')
        self.sock.sendall(b'+')
        data = bytearray()
        i = 0
        while i < len(wire):
            ch = wire[i]
            if ch == ord('}'):
                i += 1
                data.append(wire[i] ^ 0x20)
            elif ch == ord('*'):
                i += 1
                data.extend([data[-1]] * (wire[i] - 29))
            else:
                data.append(ch)
            i += 1
        return data.decode('ascii')

    def command(self, command, wait=True):
        payload = command.encode('ascii')
        self.sock.sendall(b'$' + payload + b'#' + f'{sum(payload)%256:02x}'.encode())
        if not wait:
            return None
        reply = self.receive()
        # A QMP stop or a newly connected debugger can queue an unsolicited
        # stop packet. It is not the answer to a memory/register/breakpoint
        # request. Execution commands and '?' do expect stop packets.
        if command not in ('?',) and not command.startswith(('c', 's', 'vCont')):
            while reply.startswith('T') or (len(reply) == 3 and reply.startswith('S')):
                reply = self.receive()
        return reply

    def interrupt(self):
        self.sock.sendall(b'\x03')
        return self.receive()


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('commands', nargs='+')
    args = p.parse_args()
    remote = Remote()
    try:
        for cmd in args.commands:
            print(cmd, remote.interrupt() if cmd == 'interrupt' else remote.command(cmd))
    finally:
        remote.close()
