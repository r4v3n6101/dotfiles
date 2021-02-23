xrdb ~/.config/xorg/.Xresources
setxkbmap -layout us,ru -option 'grp:alt_shift_toggle'
feh --bg-fill ~/.config/wallpaper/bg.jpg &
compton -b -f &
dunst &
sh ~/.config/scripts/launch_polybar.sh
dex -a -s ~/.config/autostart/ &
