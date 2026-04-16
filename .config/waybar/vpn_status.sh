#!/usr/bin/env bash
set -euo pipefail

state=$(piactl get connectionstate)

if [[ "$state" == "Connected" ]]; then
  region=$(piactl get region)
  printf '{"text":"%s","class":"connected"}\n' "$region"
else
  printf '{"text":"VPN off","class":"disconnected"}\n'
fi
