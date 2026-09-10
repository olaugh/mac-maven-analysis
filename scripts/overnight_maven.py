#!/usr/bin/env python3
"""Token-free supervisor for one continuous original/reconstructed Maven batch.
Requires the owned QEMU VM with a freshly launched Maven application. Never
restarts either engine, patches guest memory, or invokes a model service.
"""
import argparse
import fcntl
import hashlib
import json
import os
from pathlib import Path
import shutil
import signal
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[1]
from qmp_session import command


def atomic_json(path, value):
    temporary = path.with_suffix('.tmp')
    temporary.write_text(json.dumps(value, indent=2) + '\n')
    temporary.replace(path)


def read_report(path):
    try:
        return json.loads(path.read_text())
    except (FileNotFoundError, json.JSONDecodeError):
        return {}


def classify(report, returncode):
    if report.get('issues'):
        return 'DISAGREEMENT'
    if report.get('failure') or returncode != 0:
        return 'ERROR'
    if report.get('stop_reason'):
        return 'STOPPED'
    return 'COMPLETE' if report.get('complete') else 'ERROR'


def process_identity(pid):
    return subprocess.check_output(['ps', '-p', str(pid), '-o', 'lstart=', '-o', 'command='], text=True).strip()


def fingerprints():
    paths = list((ROOT/'scripts').glob('*.py'))
    paths += list((ROOT/'reconstruction').glob('*.[ch]'))
    paths += [p for p in (ROOT/'resources').rglob('*') if p.is_file()]
    paths += [ROOT/'.build/magpie-match.dylib', ROOT/'../../media/maven/session/share/maven2.1']
    paths += [ROOT/'../../magpie-pr-619'/p for p in ('bin/magpie', 'data/lexica/NWLMAVEN.kwg', 'data/lexica/NWLMAVEN.wmp', 'data/lexica/NWLMAVEN.klv2')]
    return {str(p.resolve()): hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}


def stop_child(child):
    if child.poll() is None:
        child.terminate()
        try:
            child.wait(timeout=20)
        except subprocess.TimeoutExpired:
            # This process group belongs exclusively to the batch and its Magpie child.
            os.killpg(child.pid, signal.SIGKILL)
            child.wait(timeout=10)


def supervise(args):
    run = args.run_dir.resolve()
    run.mkdir(parents=True, exist_ok=True)
    lock = open('/tmp/maven-comparison-supervisor.lock', 'w')
    fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    if (run/'status.json').exists():
        raise RuntimeError('Run directory already has status; use a new directory. Completed runs never restart.')
    identity = process_identity(args.qemu_pid)
    if 'qemu-system-m68k' not in identity or '/tmp/maven-re-qmp.sock' not in identity or '-snapshot' not in identity:
        raise RuntimeError('PID is not the expected disposable Maven QEMU')
    source_hashes = fingerprints()
    atomic_json(run/'manifest.json', dict(files=source_hashes, qemu_pid=args.qemu_pid, qemu_identity=identity,
        seed=args.seed, hours=args.hours, games=args.games, ui_delay_scale=args.ui_delay_scale))
    status = dict(state='STARTING', supervisor_pid=os.getpid(), qemu_pid=args.qemu_pid,
        started=time.time(), run_dir=str(run), max_seconds=int(args.hours*3600), heartbeat_seconds=5,
        source_check_seconds=60, stall_limit_seconds=args.stall_seconds, model_calls=0)
    report_path = run/'games.json'
    child = None
    caffeine = None
    reason = None
    def request_stop(signum, frame):
        (run/'STOP').touch()
    signal.signal(signal.SIGTERM, request_stop)
    signal.signal(signal.SIGINT, request_stop)
    try:
        # Keep the host awake only while this supervisor is alive.
        if Path('/usr/bin/caffeinate').exists():
            caffeine = subprocess.Popen(['/usr/bin/caffeinate', '-i', '-w', str(os.getpid())])
        with (run/'games.log').open('w') as log:
            child = subprocess.Popen([sys.executable, '-u', str(ROOT/'scripts/play_original_magpie_matches.py'),
                '--games', str(args.games), '--seed', str(args.seed), '--max-seconds', str(int(args.hours*3600)),
                '--ui-delay-scale', str(args.ui_delay_scale), '--stop-file', str(run/'STOP'), '--pause-on-exit',
                '--heartbeat-file', str(run/'heartbeat.json'),
                '--output', str(report_path)], cwd=ROOT, stdin=subprocess.DEVNULL, stdout=log,
                stderr=subprocess.STDOUT, start_new_session=True)
            status.update(state='RUNNING', batch_pid=child.pid)
            last_positions, progressed, last_hash_check = -1, time.monotonic(), time.monotonic()
            last_beat = None
            while child.poll() is None:
                report = read_report(report_path)
                count = report.get('positions', 0)
                now = time.monotonic()
                if count != last_positions:
                    last_positions, progressed = count, now
                # A long endgame search stops the debugger at every clock read;
                # each stop rewrites the heartbeat, so only a silent driver is a stall.
                beat = read_report(run/'heartbeat.json')
                if beat and beat != last_beat:
                    last_beat, progressed = beat, now
                    status['last_heartbeat'] = beat
                status.update(updated=time.time(), positions=count, completed_games=report.get('completed_games', 0),
                    ranked_records=report.get('ranked_records', 0), seconds_since_progress=round(now-progressed, 1))
                atomic_json(run/'status.json', status)
                if report.get('issues'):
                    reason = 'DISAGREEMENT'
                    break
                if now-progressed > args.stall_seconds:
                    reason = 'STALLED'
                    break
                if time.time()-status['started'] > status['max_seconds']+args.stall_seconds:
                    reason = 'TIME_LIMIT_OVERRUN'
                    break
                if now-last_hash_check >= 60:
                    if fingerprints() != source_hashes:
                        reason = 'SOURCE_CHANGED'
                        break
                    if process_identity(args.qemu_pid) != identity:
                        reason = 'VM_CHANGED'
                        break
                    if shutil.disk_usage(run).free < 1024**3:
                        reason = 'LOW_DISK_SPACE'
                        break
                    last_hash_check = now
                time.sleep(5)
            stop_child(child)
        report = read_report(report_path)
        status.update(state=reason or classify(report, child.returncode), batch_returncode=child.returncode,
            positions=report.get('positions', 0), completed_games=report.get('completed_games', 0),
            ranked_records=report.get('ranked_records', 0), stop_reason=report.get('stop_reason'),
            failure=report.get('failure'), issues=report.get('issues', []))
    except Exception as exc:
        if child:
            stop_child(child)
        status.update(state='ERROR', supervisor_error=repr(exc))
    finally:
        # No reset or quit: leave the original process paused for the next debugger.
        try:
            if process_identity(args.qemu_pid) != identity:
                raise RuntimeError('VM identity changed; refusing to touch its socket')
            command('stop')
            status['vm_paused'] = True
            if status['state'] not in ('COMPLETE', 'STOPPED'):
                try:
                    command('screendump', {'filename': str(run/'failure.ppm')})
                    subprocess.run(['sips', '-s', 'format', 'png', str(run/'failure.ppm'), '--out', str(run/'failure.png')], capture_output=True)
                except Exception as exc:
                    status['screenshot_error'] = repr(exc)
                try:
                    # q800 does not support QMP dump-guest-memory. Preserve its
                    # configured 128 MB physical RAM plus the live CPU registers.
                    from gdb_remote import Remote
                    remote = Remote()
                    try:
                        assert remote.command('m40800000,10') == 'f1acad130000002a067c4efa00804efa'
                        atomic_json(run/'failure-registers.json', dict(gdb_registers=remote.command('g'), ram_base=0, ram_bytes=128*1024*1024))
                    finally:
                        remote.close()
                    ram_path = run/'failure.ram'
                    if any(c in str(ram_path) for c in ('\"', '\\', '\n')):
                        raise ValueError('Unsupported monitor filename')
                    reply = command('human-monitor-command', {'command-line': f'pmemsave 0 134217728 \"{ram_path}\"'})
                    if not ram_path.exists() or ram_path.stat().st_size != 128*1024*1024:
                        raise RuntimeError(('RAM dump failed', reply))
                    status['memory_dump_complete'] = True
                except Exception as exc:
                    status['memory_dump_error'] = repr(exc)
        except Exception as exc:
            status['pause_error'] = repr(exc)
        status.update(updated=time.time(), finished=time.time())
        atomic_json(run/'status.json', status)
        (run/'DONE').write_text(status['state']+'\n')
        if status['state'] not in ('COMPLETE', 'STOPPED'):
            (run/'ALERT').write_text(json.dumps(status, indent=2)+'\n')
        if caffeine:
            caffeine.terminate()
            caffeine.wait(timeout=10)
    print(json.dumps(status), flush=True)
    return 0 if status['state'] in ('COMPLETE', 'STOPPED') else 2


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--run-dir', type=Path, required=True)
    p.add_argument('--qemu-pid', type=int, required=True)
    p.add_argument('--hours', type=float, default=12)
    p.add_argument('--games', type=int, default=50000)
    p.add_argument('--seed', type=int, default=9102070)
    p.add_argument('--ui-delay-scale', type=float, default=.25)
    p.add_argument('--stall-seconds', type=float, default=120, help='Seconds without a completed position or a driver heartbeat')
    p.add_argument('--detach', action='store_true')
    args=p.parse_args()
    if args.hours <= 0 or args.games <= 0 or args.stall_seconds <= 0 or not 0 < args.ui_delay_scale <= 1:
        p.error('positive runtime/game/watchdog limits and a UI scale in (0,1] are required')
    if args.detach:
        args.run_dir.resolve().mkdir(parents=True, exist_ok=True)
        with (args.run_dir/'supervisor.log').open('a') as log:
            child=subprocess.Popen([sys.executable, '-u', str(Path(__file__).resolve()),
                *[arg for arg in sys.argv[1:] if arg != '--detach']], cwd=ROOT,
                stdin=subprocess.DEVNULL, stdout=log, stderr=subprocess.STDOUT, start_new_session=True)
        print(json.dumps(dict(supervisor_pid=child.pid, run_dir=str(args.run_dir.resolve()))))
        return 0
    return supervise(args)

if __name__ == '__main__':
    sys.exit(main())
