#!/bin/bash
# Shared setup for the kitchen scripts. Environment:
#   ROMS_DIR     where ROM source trees live (one subdirectory per ROM), default ~/roms
#   RELEASE_DIR  where finished zips are copied, default $ROMS_DIR/release
KITCHEN=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
ROMS_DIR=${ROMS_DIR:-$HOME/roms}
RELEASE_DIR=${RELEASE_DIR:-$ROMS_DIR/release}

load_rom() {
    ROM=$1
    CONF=$KITCHEN/roms/$ROM/rom.conf
    [ -f "$CONF" ] || { echo "no rom.conf for '$ROM' ($CONF)" >&2; exit 2; }
    # shellcheck source=/dev/null
    source "$CONF"
    ROM_KITCHEN=$KITCHEN/roms/$ROM
    TREE=$ROMS_DIR/$ROM
}
