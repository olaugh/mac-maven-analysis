#!/usr/bin/env python3
"""Describe observed features of original endgame traces, not branch completeness."""
import argparse
import gzip
import json
from pathlib import Path
import struct


def reachable_nodes(raw):
    """Follow original child/sibling links; preserve shared-node observations."""
    capacity = len(raw) // 32
    seen, pending, incoming = {0}, [0], {}
    while pending:
        parent = pending.pop()
        child = struct.unpack_from('>H', raw, parent * 32 + 4)[0]
        siblings = set()
        while child:
            assert 0 < child < capacity and child not in siblings
            siblings.add(child)
            incoming[child] = incoming.get(child, 0) + 1
            if child not in seen:
                seen.add(child)
                pending.append(child)
            child = struct.unpack_from('>H', raw, child * 32 + 6)[0]
    return seen, incoming


def describe(path):
    capture = json.loads(gzip.decompress(path.read_bytes()))
    assert capture['complete']
    pass_examples, shared_examples, maximum = [], [], 0
    for iteration, state in enumerate(capture['iterations'], 1):
        raw = bytes.fromhex(state['nodes'])
        reachable, incoming = reachable_nodes(raw)
        maximum = max(maximum, len(reachable))
        passes = [index for index in sorted(reachable) if index and raw[index * 32 + 26] == 0]
        shared = [index for index, parents in sorted(incoming.items()) if parents > 1]
        if passes and not pass_examples:
            pass_examples = [dict(iteration=iteration, node=index) for index in passes]
        if shared and not shared_examples:
            shared_examples = [dict(iteration=iteration, node=index, parents=incoming[index])
                               for index in shared]
    pass_leaf_entries = []
    for index, leaf in enumerate(capture['leaf_entries']):
        # Nodes were allocated in earlier completed iterations; classify the
        # actual next leaf target before this leaf can mutate/recycle the pool.
        if index and leaf['current']:
            previous = bytes.fromhex(capture['iterations'][index - 1]['nodes'])
            if previous[32 * leaf['current'] + 26] == 0:
                pass_leaf_entries.append(dict(iteration=index + 1, node=leaf['current']))
    rack = lambda key: bytes.fromhex(capture[key]).split(b'\0', 1)[0].decode('ascii')
    return dict(capture=path.name, iterations=len(capture['iterations']),
                own=rack('own'), other=rack('other'),
                no_iteration_return=not capture['iterations'],
                maximum_observed_reachable_nodes=maximum,
                first_reachable_pass_nodes=pass_examples,
                pass_leaf_entries=pass_leaf_entries,
                first_shared_child_nodes=shared_examples,
                explicit_collection_stages=len(capture.get('collections', [])),
                ranked_moves=capture['final']['ranking']['count'])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('captures', nargs='+', type=Path)
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    report = dict(scope=__doc__, captures=[describe(path) for path in args.captures])
    text = json.dumps(report, indent=2) + '\n'
    if args.output:
        args.output.write_text(text)
    print(text, end='')


if __name__ == '__main__':
    main()
