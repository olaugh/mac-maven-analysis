#!/usr/bin/env python3
"""Read-only, token-free Maven monitor. Exit 2 on failure, 3 on stale heartbeat.
--stop requests a graceful stop at the next position boundary. --notify also
shows a local macOS notification on failure; this never contacts a model.
"""
import argparse
import json
import os
from pathlib import Path
import subprocess
import sys
import time

GOOD_TERMINAL = {'COMPLETE', 'STOPPED'}
ACTIVE = {'STARTING', 'RUNNING'}


def inspect(run, now=None):
    now = time.time() if now is None else now
    try:
        status = json.loads((run/'status.json').read_text())
    except (FileNotFoundError, json.JSONDecodeError):
        return 'WAITING', 3, 'No readable supervisor status yet.'
    state = status.get('state', 'UNKNOWN')
    if state in ACTIVE and now-status.get('updated', status.get('started', 0)) > 30:
        return 'STALE', 3, 'Supervisor heartbeat is older than 30 seconds; inspect processes and logs.'
    line = (f"{state}: {status.get('completed_games', 0)} games, "
            f"{status.get('positions', 0)} positions, {status.get('ranked_records', 0)} ranked moves")
    detail = status.get('failure') or status.get('supervisor_error') or status.get('stop_reason')
    if detail:
        line += ' | '+str(detail)
    code = 0 if state in ACTIVE | GOOD_TERMINAL else 2
    return state, code, line


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('run_dir', type=Path)
    p.add_argument('--once', action='store_true')
    p.add_argument('--stop', action='store_true')
    p.add_argument('--notify', action='store_true')
    p.add_argument('--interval', type=float, default=5)
    a=p.parse_args()
    if a.interval <= 0:p.error('--interval must be positive')
    run=a.run_dir.resolve()
    if not run.is_dir():p.error('Run directory does not exist')
    if a.stop:
        (run/'STOP').touch()
        print('Requested graceful stop; the supervisor will pause the VM and preserve the log.')
        return 0
    previous=None
    waiting_since=time.monotonic()
    while True:
        state, code, line = inspect(run)
        if state == 'WAITING' and time.monotonic()-waiting_since > 30:
            state, code, line = 'STALE', 3, 'No supervisor status after 30 seconds; inspect supervisor.log.'
        if line != previous:
            print(time.strftime('%H:%M:%S')+' '+line, flush=True)
            previous=line
        if state not in ACTIVE and state != 'WAITING':
            if code:
                print('\aEvidence: '+str(run/'status.json')+'; '+str(run/'games.log'), flush=True)
                if a.notify and Path('/usr/bin/osascript').exists():
                    subprocess.run(['/usr/bin/osascript', '-e',
                        'display notification "Maven comparison needs attention. Open the run monitor and evidence." with title "Maven comparison stopped" sound name "Glass"'], check=False)
            return code
        if a.once:return code
        time.sleep(a.interval)

if __name__ == '__main__':
    sys.exit(main())
