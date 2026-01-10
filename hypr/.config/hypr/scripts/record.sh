#!/usr/bin/env bash
set -euo pipefail

SAVE_DIR="$HOME/Videos/recordings"
mkdir -p "$SAVE_DIR"

PIDFILE="$HOME/.cache/wf-recorder.pid"
mkdir -p "$(dirname "$PIDFILE")"

notify() {
  if command -v dunstify >/dev/null 2>&1; then
    dunstify -a "Recorder" "$@"
  else
    notify-send "$@"
  fi
}

open_latest() {
  local latest
  latest="$(ls -t "$SAVE_DIR"/*.mp4 2>/dev/null | head -1 || true)"

  if [[ -z "${latest:-}" ]]; then
    notify "Recording stopped" "No recordings found"
    return 0
  fi

  if command -v losslesscut >/dev/null 2>&1; then
    notify "Recording stopped" "Opening in LosslessCut"
    losslesscut "$latest" &
  else
    notify "Recording stopped" "Opening in VLC"
    vlc "$latest" &
  fi
}
# ----------------------------
# STOP if already recording
# ----------------------------
if [[ -f "$PIDFILE" ]]; then
  PID="$(cat "$PIDFILE" || true)"
  if [[ -n "${PID:-}" ]] && kill -0 "$PID" 2>/dev/null; then
    kill -INT "$PID" 2>/dev/null || true
    sleep 2
    kill -0 "$PID" 2>/dev/null && kill -KILL "$PID" 2>/dev/null || true
    rm -f "$PIDFILE"
    open_latest
    exit 0
  else
    rm -f "$PIDFILE"
  fi
fi

# ----------------------------
# START recording
# ----------------------------
FILENAME="$SAVE_DIR/Recording-$(date +%F_%H-%M-%S).mp4"

if [[ "${1:-}" == "region" ]]; then
  REGION="$(slurp)" || exit 1
  wf-recorder -c libx264 -g "$REGION" -f "$FILENAME" >/tmp/wf-recorder.log 2>&1 &
else
  # Record the currently focused monitor output name
  OUTPUT="$(
    hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name' | head -1
  )"

  if [[ -z "${OUTPUT:-}" ]]; then
    notify "Recording failed" "Couldn't detect focused monitor"
    exit 1
  fi

  # Record one output. In multi-output setups, -o is the correct way. :contentReference[oaicite:2]{index=2}
  wf-recorder -c libx264 -o "$OUTPUT" -f "$FILENAME" >/tmp/wf-recorder.log 2>&1 &
fi

echo $! >"$PIDFILE"

# Detect instant failure
sleep 0.15
PID="$(cat "$PIDFILE" || true)"
if [[ -n "${PID:-}" ]] && ! kill -0 "$PID" 2>/dev/null; then
  rm -f "$PIDFILE"
  notify "Recording failed" "wf-recorder exited. See /tmp/wf-recorder.log"
  exit 1
fi

# Show notification with action button to stop
(
    action=$(notify-send "Recording started" "Click to stop" --action="stop=Stop Recording")
    if [[ "$action" == "stop" ]]; then
        ~/.config/hypr/scripts/record.sh
    fi
) &
