#!/bin/sh

if [ -z "$SSH_AUTH_SOCK" ] || [ ! -S "$SSH_AUTH_SOCK" ]; then
    rm -f ~/.ssh/ssh-agent.sock
    eval "$(ssh-agent -s -a ~/.ssh/ssh-agent.sock)"
fi
export SSH_AUTH_SOCK=~/.ssh/ssh-agent.sock

termux-x11 :1 -xstartup "keepassxc" &
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity
