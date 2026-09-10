#!/usr/bin/env python3
"""Keyboard and calibrated ADB clicks for the isolated classic Mac session.

Read Mouse (Point at 0x830) only as feedback; never write mouse globals.
Caller must inspect a current screenshot before choosing a coordinate.
"""
import argparse
import re
import time
from qmp_session import command


def key(value, delay=.08):
    command('human-monitor-command', {'command-line': f'sendkey {value} 30'})
    time.sleep(delay)


def text(value, delay=.08):
    punctuation = {' ': 'spc', '.': 'dot', '-': 'minus', '_': 'shift-minus'}
    for c in value:
        if c in punctuation:
            k = punctuation[c]
        elif c.isascii() and c.isalnum():
            k = ('shift-' if c.isupper() else '') + c.lower()
        else:
            raise ValueError(f'unsupported character {c!r}')
        key(k, delay=delay)


def position():
    reply = command('human-monitor-command', {'command-line': 'x /4bx 0x830'})
    b = bytes(int(x, 16) for x in re.findall(r'0x([0-9a-f]{2})', reply))
    if len(b) != 4:
        raise ValueError(f'not a mouse point: {reply}')
    return int.from_bytes(b[2:4], 'big'), int.from_bytes(b[:2], 'big')


def move_to(x, y):
    for _ in range(120):
        px, py = position()
        if abs(px-x) <= 1 and abs(py-y) <= 1:
            break
        # ADB/Finder accelerates pointer motion, so use measured small steps.
        dx = max(-12, min(12, (x-px)//2)) if abs(x-px)>1 else 0
        dy = max(-12, min(12, (y-py)//2)) if abs(y-py)>1 else 0
        command('input-send-event', {'events': [
            {'type':'rel', 'data':{'axis':'x', 'value':dx}},
            {'type':'rel', 'data':{'axis':'y', 'value':dy}}]})
        time.sleep(.05)
    else:
        raise RuntimeError(f'mouse failed to converge: {position()} -> {(x,y)}')


def click(x, y, count=1):
    move_to(x,y)
    for _ in range(count):
        for down in [True, False]:
            command('input-send-event', {'events':[
                {'type':'btn', 'data':{'button':'left', 'down':down}}]})
            time.sleep(.07)


def drag(source_x, source_y, target_x, target_y):
    move_to(source_x,source_y)
    time.sleep(.5) # Separate from preceding clicks: title double-click shades windows.
    command('input-send-event',{'events':[
        {'type':'btn','data':{'button':'left','down':True}}]})
    try:
        time.sleep(.1)
        move_to(target_x,target_y)
        time.sleep(.3) # Let MenuSelect/DragManager consume the final motion.
    finally:
        command('input-send-event',{'events':[
            {'type':'btn','data':{'button':'left','down':False}}]})
    time.sleep(.2)


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('action', choices=['key','text','click'])
    p.add_argument('values', nargs='+')
    a = p.parse_args()
    if a.action == 'key':
        for k in a.values: key(k)
    elif a.action == 'text': text(' '.join(a.values))
    else: click(*(int(v) for v in a.values))
