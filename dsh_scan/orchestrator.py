#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Queue runner: execute task commands, at most W at a time.
Tasks file: each line = one command. Output -> dsh_scan/logs/<idx>_<name>.log
Usage: python3 orchestrator.py tasks.txt W"""
import sys, os, subprocess, time

tasks_file = sys.argv[1]
W = int(sys.argv[2])
os.makedirs("dsh_scan/logs", exist_ok=True)
lines = [l.strip() for l in open(tasks_file) if l.strip() and not l.startswith("#")]
jobs = []
for idx, cmd in enumerate(lines):
    name = cmd.split()[1].split("/")[-1] + "_" + str(idx)
    log = f"dsh_scan/logs/{idx:02d}_{name}.log"
    jobs.append((idx, cmd, log))

pending = list(jobs)
running = {}  # log -> (proc, idx)
done_logs = set()
while pending or running:
    while len(running) < W and pending:
        idx, cmd, log = pending.pop(0)
        if os.path.exists(log) and os.path.getsize(log) > 0:
            done_logs.add(log)
            print(f"[{idx}] skipped (log exists): {cmd}", flush=True)
            continue
        print(f"[{idx}] start: {cmd}", flush=True)
        with open(log, "w") as f:
            f.write(f"# {cmd}\n")
        p = subprocess.Popen(cmd, shell=True, stdout=open(log, "a"), stderr=subprocess.STDOUT)
        running[log] = (p, idx)
    # reap
    finished = []
    for log, (p, idx) in running.items():
        rc = p.poll()
        if rc is not None:
            finished.append(log)
            print(f"[{idx}] finished rc={rc}: {log}", flush=True)
    for log in finished:
        del running[log]
    if pending or running:
        time.sleep(5)
print("ALL DONE", flush=True)
