#!/bin/bash

# Toggle rofi menu on/off depending on current state
ROFI_PROC="rofi"
ROFI_CMD="rofi -show drun -show-icons"

if pgrep -x "$ROFI_PROC" > /dev/null; then
    pkill -x "$ROFI_PROC"
else
    $ROFI_CMD &
fi
