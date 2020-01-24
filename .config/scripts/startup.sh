setxkbmap -layout us,ru -option 'grp:alt_shift_toggle'
feh --bg-fill ~/bg.jpg &
compton -b -f &
sh ~/.config/scripts/launch_polybar.sh
dex -a &
dunst &
