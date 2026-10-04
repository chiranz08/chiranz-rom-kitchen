#!/bin/bash
# Run queued builds one at a time; a build starts only when enough disk is free. Never deletes anything.
# Queue file ($QUEUE_DIR/pending.txt) lines: "<rom> <variant> <jobs> <min_free_GB>"; a line "STOP" ends the runner.
# Start detached:  setsid scripts/queue.sh >> "$QUEUE_DIR/runner.log" 2>&1 < /dev/null &
source "$(dirname "$0")/common.sh"
QUEUE_DIR=${QUEUE_DIR:-$ROMS_DIR/queue}; LOG_DIR=${LOG_DIR:-$ROMS_DIR/logs}
Q=$QUEUE_DIR/pending.txt; mkdir -p "$QUEUE_DIR" "$LOG_DIR"; touch "$Q"
log() { echo "[$(date '+%F %T')] $*"; }
log "queue runner started"
while true; do
    line=$(grep -v '^\s*#' "$Q" | grep -v '^\s*$' | head -1)
    [ -z "$line" ] && { sleep 60; continue; }
    [ "$line" = STOP ] && { sed -i '0,/^STOP$/{/^STOP$/d}' "$Q"; log "STOP"; exit 0; }
    read -r rom variant jobs need <<<"$line"
    free=$(df -BG --output=avail "$ROMS_DIR" | tail -1 | tr -dc 0-9)
    if [ "$free" -lt "$need" ]; then
        # Re-read the queue every round so a re-ordered queue takes effect while waiting.
        log "WAITING $rom: ${free}G free, need ${need}G"; sleep 300; continue
    fi
    sed -i "0,/^$(printf '%s' "$line" | sed 's/[]\/$*.^[]/\\&/g')$/{//d}" "$Q"
    L=$LOG_DIR/$rom-$(date +%Y%m%d-%H%M).log; ln -sfn "$L" "$LOG_DIR/current.log"
    log "START $rom ($variant, -j$jobs, ${free}G free) log=$L"
    if "$KITCHEN/scripts/build.sh" "$rom" "$variant" "$jobs" > "$L" 2>&1; then
        log "DONE $rom OK"; echo "$line" >> "$QUEUE_DIR/done.txt"
    else
        log "DONE $rom FAILED (see $L)"; echo "$line" >> "$QUEUE_DIR/failed.txt"
    fi
done
