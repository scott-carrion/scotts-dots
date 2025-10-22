#!/bin/bash
# Add this script to your wm startup file.

DIR="$HOME/.config/polybar/hack"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar (XXX DEFAULT, REMOVE
#polybar -q top -c "$DIR"/config.ini &
#polybar -q bottom -c "$DIR"/config.ini &

# Detect monitors and choose polybar configs to launch accordingly
# Definition of display identifier for left and right monitors
# Use "xrandr --query" if this isn't working to see if these are correct
left_monitor="DP-0"
right_monitor="DP-2"
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    # Launch Polybar instances (multiple monitors)
    if [ $m == $right_monitor ]
    then
      echo "Starting top + bottom polybar for right monitor ($right_monitor)"
      MONITOR=$m polybar -r -c "$DIR"/config.ini top_right_monitor &
      MONITOR=$m polybar -r -c "$DIR"/config.ini bottom_right_monitor &

    elif [ $m == $left_monitor ]
    then
      echo "Starting top + bottom polybar for left monitor ($left_monitor)"
      MONITOR=$m polybar -r -c "$DIR"/config.ini top_left_monitor &
      MONITOR=$m polybar -r -c "$DIR"/config.ini bottom_left_monitor &

    # In the case where no monitor matches the setup, use current monitor m as single monitor and break
    else
      echo "Starting top + bottom polybar for single monitor ($m)"
      # Launch Polybar instances (single monitor)
      MONITOR=$m polybar -r -c "$DIR"/config.ini top &
      MONITOR=$m polybar -r -c "$DIR"/config.ini bottom &
      break
    fi
  done
else
  # If xrandr doesn't exist, echo error message
  echo "ERROR: 'type xrandr' failed. Does xrandr exist in \$PATH?"
  exit 1
fi

