#!/usr/bin/env bash
# WaybarCava.sh — safer single-instance handling, cleanup, and robustness
# Original concept by JaKooLit; this variant focuses on lifecycle hardening.

set -euo pipefail

# Ensure cava exists
if ! command -v cava >/dev/null 2>&1; then
  echo "cava not found in PATH" >&2
  exit 1
fi

# 0..7 → ▁▂▃▄▅▆▇█
bar="▁▂▃▄▅▆▇█"
dict="s/;//g"
bar_length=${#bar}
for ((i = 0; i < bar_length; i++)); do
  dict+=";s/$i/${bar:$i:1}/g"
done

# Single-instance guard, scoped per output: waybar starts one instance of this
# script per bar/monitor, so a pidfile shared across outputs makes concurrent
# startups race and kill each other, leaking orphaned cava processes.
RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}"
pidfile="$RUNTIME_DIR/waybar-cava.${WAYBAR_OUTPUT_NAME:-default}.pid"
if [[ -f "$pidfile" ]]; then
  oldpid="$(cat "$pidfile" || true)"
  if [[ -n "$oldpid" ]] && kill -0 "$oldpid" 2>/dev/null; then
    # Signal the whole process group: the old script's cava/sed pipeline
    # children don't die with it otherwise, and its own trap just runs
    # cleanup on TERM without exiting unless its children have already gone.
    kill -TERM -- "-$oldpid" 2>/dev/null || true
    sleep 0.1 || true
  fi
fi
printf '%d' $$ >"$pidfile"

# Unique temp config + cleanup on exit. A trap only runs its handler, it
# doesn't terminate the process by itself, so INT/TERM must exit explicitly
# or the script (and its still-running cava/sed pipeline) would survive the
# very signal meant to stop it.
config_file="$(mktemp "$RUNTIME_DIR/waybar-cava.XXXXXX.conf")"
cleanup() { rm -f "$config_file" "$pidfile"; }
trap cleanup EXIT
trap 'cleanup; exit 0' INT TERM

# If waybar is killed without signaling its children (e.g. SIGKILL), this
# script would otherwise be orphaned forever; watch our parent and clean up
# once it's gone instead of leaking cava/sed processes. Signal the whole
# process group so the pipeline children go down with it.
parent_pid=$PPID
(
  while kill -0 "$parent_pid" 2>/dev/null; do
    sleep 2
  done
  cleanup
  kill -TERM -- "-$$" 2>/dev/null
) &

cat >"$config_file" <<EOF
[general]
framerate = 30
bars = 10

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

# Stream cava output and translate digits 0..7 to bar glyphs
exec cava -p "$config_file" | sed -u "$dict"
