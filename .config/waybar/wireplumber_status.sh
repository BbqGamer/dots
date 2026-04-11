#!/usr/bin/env bash
set -euo pipefail

command -v wpctl >/dev/null 2>&1 || exit 1

get_desc() {
  local what="$1"
  wpctl inspect "$what" 2>/dev/null | awk -F' = "' '
    $1 ~ /node\.description/ {
      sub(/"$/, "", $2)
      print $2
      exit
    }
  '
}

get_volume() {
  local what="$1"
  local vol
  vol="$(wpctl get-volume "$what" 2>/dev/null | awk '{print $2}')"
  awk -v v="$vol" 'BEGIN { printf("%d", (v * 100) + 0.5) }'
}

sink_desc="$(get_desc @DEFAULT_AUDIO_SINK@ || true)"
sink_vol="$(get_volume @DEFAULT_AUDIO_SINK@ || echo 0)"

if [[ -z "${sink_desc:-}" ]]; then
  sink_desc="Audio"
fi

if (( sink_vol >= 100 )); then
  icon=""
elif (( sink_vol >= 50 )); then
  icon=""
else
  icon=""
fi

printf '{"text":"%s %s%%","tooltip":"Output: %s"}\n' \
  "$icon" \
  "$sink_vol" \
  "$sink_desc"
