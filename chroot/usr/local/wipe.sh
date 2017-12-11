#!/bin/bash
export DISPLAY=:0
xfce4-terminal --title $DEVNAME -e "shred -fuvz $DEVNAME"
