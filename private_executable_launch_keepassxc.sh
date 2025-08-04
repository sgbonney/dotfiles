#!/bin/sh

# Start SSH agent if not already running
if [ -z "$SSH_AUTH_SOCK" ] || [ ! -S "$SSH_AUTH_SOCK" ]; then
    # Remove the old socket file if it exists
    rm -f ~/.ssh/ssh-agent.sock
    eval "$(ssh-agent -s -a ~/.ssh/ssh-agent.sock)"
fi

# Set SSH_AUTH_SOCK to the fixed socket location
export SSH_AUTH_SOCK=~/.ssh/ssh-agent.sock

termux-x11 :1 -xstartup "keepassxc" &
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity
