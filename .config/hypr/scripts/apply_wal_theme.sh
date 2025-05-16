#!/bin/bash

THEME_FILE="/tmp/theme_variant"
wal_arguments=""

if [ -s "$THEME_FILE" ]; then
  case $(<"$THEME_FILE") in
    "light") wal_arguments="-C ~/.config/wallust/wallust-light.toml" ;;
    *) wal_arguments="-C ~/.config/wallust/wallust-dark.toml" ;;
  esac
fi

matugen image ~/Pictures/wallpaper.png $wal_arguments -q
wallust run ~/Pictures/wallpaper.png -w -q


# Restart waybar
pgrep -x "waybar" > /dev/null && killall -SIGUSR2 waybar

# Restart cava
pkill -USR2 cava # Reloads cava's colorscheme configuration

spicetify apply -q -n
