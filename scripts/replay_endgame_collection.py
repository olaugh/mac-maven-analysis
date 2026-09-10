#!/usr/bin/env python3
"""Compare original pool-exhaustion pruning, marking and sweep at every node."""
import argparse
import ctypes as C
import gzip
import hashlib
import json
from pathlib import Path
import struct
import subprocess
import tempfile


class Node(C.Structure):
    _fields_ = [
        ('lower', C.c_int16), ('upper', C.c_int16),
        ('first_child', C.c_uint16), ('next_sibling', C.c_uint16),
        ('reserved_word', C.c_uint16), ('move_score', C.c_int16),
        ('position_hash', C.c_uint32), ('placed_tiles', C.c_uint8 * 8),
    ] + [(name, C.c_uint8) for name in (
        'adjustment_tag', 'kept_mask', 'row', 'column',
        'emptied_rack', 'leave_tag', 'mark', 'reserved_byte',
    )]


Callback = C.CFUNCTYPE(None, C.c_void_p)


class Tree(C.Structure):
    _fields_ = [
        ('nodes', C.POINTER(Node)), ('capacity', C.c_uint16),
        ('free_head', C.c_uint16), ('current', C.c_uint16),
        ('diagnostic', Callback), ('poll', Callback), ('user', C.c_void_p),
    ]


NODE_FORMAT = '>hhHHHhI8s8B'


def unpack_nodes(raw, capacity):
    assert len(raw) == capacity * 32
    nodes = (Node * capacity)()
    for index in range(capacity):
        values = struct.unpack_from(NODE_FORMAT, raw, 32 * index)
        for (name, _), value in zip(Node._fields_, values):
            if name == 'placed_tiles':
                nodes[index].placed_tiles[:] = value
            else:
                setattr(nodes[index], name, value)
    return nodes


def pack_nodes(nodes):
    records = []
    for node in nodes:
        values = [bytes(node.placed_tiles) if name == 'placed_tiles'
                  else getattr(node, name) for name, _ in Node._fields_]
        records.append(struct.pack(NODE_FORMAT, *values))
    return b''.join(records)


def compare(tree, nodes, state, stage):
    actual, expected = pack_nodes(nodes), bytes.fromhex(state['nodes'])
    if actual != expected:
        offset = next(i for i, (x, y) in enumerate(zip(actual, expected)) if x != y)
        raise AssertionError((stage, 'node', offset // 32, 'byte', offset % 32,
                              actual[offset], expected[offset]))
    assert tree.free_head == state['free_head'], (stage, 'free_head')
    assert tree.current == state['current'], (stage, 'current')


def free_list_length(tree):
    seen = set()
    index = tree.free_head
    while index:
        assert index < tree.capacity and index not in seen
        seen.add(index)
        index = tree.nodes[index].next_sibling
    return len(seen)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--capture', type=Path, required=True)
    args = parser.parse_args()
    capture = json.loads(gzip.decompress(args.capture.read_bytes()))
    assert capture['complete']
    code_hash = hashlib.sha256(Path('resources/CODE/30_30.bin').read_bytes()).hexdigest()
    assert any(item['code_resource'] == 30 and item['sha256'] == code_hash
               for item in capture['identities'])
    capacity = capture['capacity']
    assert C.sizeof(Node) == 32
    checkpoints = capture['collections']
    assert checkpoints and len(checkpoints) % 3 == 0
    diagnostics = []
    diagnostic = Callback(lambda _: diagnostics.append('diagnostic'))
    poll = Callback(lambda _: None)
    results = []
    with tempfile.TemporaryDirectory() as temp:
        library = Path(temp) / 'tree.dylib'
        subprocess.run(['cc', '-std=c99', '-Wall', '-Wextra', '-Werror',
                        '-dynamiclib', 'reconstruction/endgame_tree.c',
                        '-o', str(library)], check=True)
        lib = C.CDLL(str(library))
        lib.maven_endgame_prune.argtypes = [C.POINTER(Tree), C.c_uint16]
        lib.maven_endgame_mark.argtypes = [C.POINTER(Tree), C.c_uint16, C.c_uint8]
        lib.maven_endgame_sweep.argtypes = [C.POINTER(Tree)]
        for offset in range(0, len(checkpoints), 3):
            before, marked, after = checkpoints[offset:offset + 3]
            assert [item['kind'] for item in (before, marked, after)] == [
                'before_collection', 'marked_for_collection', 'after_collection']
            state = before['state']
            assert state['free_head'] == 0
            nodes = unpack_nodes(bytes.fromhex(state['nodes']), capacity)
            tree = Tree(nodes, capacity, 0, state['current'], diagnostic, poll, None)
            lib.maven_endgame_prune(C.byref(tree), 0)
            lib.maven_endgame_mark(C.byref(tree), 0, 1)
            compare(tree, nodes, marked['state'], 'pruned and marked')
            reachable = sum(bool(node.mark) for node in nodes)
            lib.maven_endgame_sweep(C.byref(tree))
            lib.maven_endgame_mark(C.byref(tree), 0, 0)
            compare(tree, nodes, after['state'], 'swept and unmarked')
            free_nodes = free_list_length(tree)
            assert reachable + free_nodes == capacity
            results.append(dict(reachable_nodes=reachable, reclaimed_nodes=free_nodes,
                                free_head=tree.free_head, current=tree.current))
    assert not diagnostics
    print(json.dumps(dict(scope=__doc__, collections=len(results),
                          nodes_per_stage=capacity, results=results, all_matched=True)))


if __name__ == '__main__':
    main()
