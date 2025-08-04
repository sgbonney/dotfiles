#!/bin/sh

termux-x11 :1 -xstartup "keepassxc" &
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity
