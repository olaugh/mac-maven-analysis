#!/bin/zsh
cd -- "${0:A:h}"
exec python3 scripts/monitor_maven.py analysis/toolchain/thousand-20260909
