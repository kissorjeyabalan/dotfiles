#!/bin/bash

THEME_FILE="/tmp/theme_variant"
#wal_arguments=""

#if [ -s "$THEME_FILE" ]; then
#  case $(<"$THEME_FILE") in
#    "light") wal_arguments="lighten -l" ;;
#  esac
#fi

#wal -i ~/Pictures/wallpaper.png --cols16 $wal_arguments -q -n -e

#pgrep -x "waybar" > /dev/null && killall -SIGUSR2 waybar

#walogram -s > /dev/null
#spicetify apply -q -n


wal_arguments=""

if [ -s "$THEME_FILE" ]; then
  case $(<"$THEME_FILE") in
    "light") wal_arguments="--light --dark-offset 0.2" ;;
    *) wal_arguments="--dark --bright-offset 0.4" ;;
  esac
fi

hellwal -i ~/Pictures/wallpaper.png $wal_arguments -q


# Restart waybar
pgrep -x "waybar" > /dev/null && killall -SIGUSR2 waybar

# Restart cava
cp $HOME/.cache/hellwal/cava.conf $HOME/.config/cava/config
pkill -USR2 cava # Reloads cava's colorscheme configuration

spicetify apply -q -n
