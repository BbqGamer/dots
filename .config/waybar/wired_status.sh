#!/usr/bin/env bash

set -euo pipefail

json_escape() {
  python3 -c 'import json,sys; print(json.dumps(sys.stdin.read().rstrip("\n")))'
}

active_if=""
active_ip=""

while read -r ifname cidr; do
  [[ $ifname == en* ]] || continue
  active_if="$ifname"
  active_ip="$cidr"
  break
done < <(ip -o -4 addr show up scope global | awk '{print $2, $4}')

if [[ -n "$active_if" ]]; then
  tooltip=$(printf '%s\nIP: %s' "$active_if" "$active_ip")
  printf '{"text":"󰈀","tooltip":%s,"class":"connected"}\n' "$(printf '%s' "$tooltip" | json_escape)"
  exit 0
fi

linked_if=""
for path in /sys/class/net/en*; do
  [[ -e "$path" ]] || continue
  ifname=${path##*/}
  carrier=$(cat "$path/carrier" 2>/dev/null || echo 0)
  if [[ "$carrier" == "1" ]]; then
    linked_if="$ifname"
    break
  fi
done

if [[ -n "$linked_if" ]]; then
  printf '{"text":"󰈀","tooltip":%s,"class":"linked"}\n' "$(printf '%s' "$linked_if connected (no IP)" | json_escape)"
else
  printf '{"text":"","tooltip":"","class":"disconnected"}\n'
fi
