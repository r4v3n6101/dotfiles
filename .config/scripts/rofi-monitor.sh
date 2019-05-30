#!/bin/sh

DIALOG_RESULT=$(echo -e 'standby\nsuspend\noff' | rofi -dmenu -i -p "monitor")

echo "This result is: $DIALOG_RESULT"
sleep 1;

if [ "$DIALOG_RESULT" = "standby" ];
then
    exec xset dpms force standby
elif [ "$DIALOG_RESULT" = "suspend" ];
then
    exec xset dpms force suspend
elif [ "$DIALOG_RESULT" = "off" ];
then
    exec xset dpms force off
fi
