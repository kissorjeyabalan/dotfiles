#!/bin/bash

THEME_FILE="/tmp/theme_variant"
wal_arguments=""
matugen_arguments=""

if [ -s "$THEME_FILE" ]; then
  case $(<"$THEME_FILE") in
    "light") 
        wal_arguments="-C ~/.config/wallust/wallust-light.toml" 
        matugen_arguments="-m light"
        ;;
    *) 
        wal_arguments="-C ~/.config/wallust/wallust-dark.toml"
        matugen_arguments="-m dark"
        ;;
  esac
fi

matugen image ~/Pictures/wallpaper.png $matugen_arguments -q
wallust run ~/Pictures/wallpaper.png $wal_arguments -w -q


# Restart waybar
pgrep -x "waybar" > /dev/null && killall -SIGUSR2 waybar

# Restart cava
pkill -USR2 cava # Reloads cava's colorscheme configuration

spicetify apply -q -n
