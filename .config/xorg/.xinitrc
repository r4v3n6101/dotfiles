[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
urxvtd -q -f -o &
exec i3
