#!/bin/bash

eval_append() {
    [ -f "$HOME/.bashrc" ] || touch "$HOME/.bashrc"
    eval "$1"
    echo -e "\n$1" >> ~/.bashrc
    source ~/.bashrc
}

handle_failure() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "Failed to install $1."
        exit 1
    fi
}

PATH_UPDATE=$(cat <<'EOF'
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
EOF
)

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    eval_append "$PATH_UPDATE"
    [ "$(passwd -S | awk '{print $2}')" == "NP" ] && passwd
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && eval_append "$(cat <<'EOF'
if [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
EOF
    )" || handle_failure "brew"
    brew install chezmoi || handle_failure "chezmoi"
elif [[ "$OSTYPE" == *"android"* ]]; then
    eval_append "$PATH_UPDATE"
    pkg update -y || { echo "Failed to update package list. Exiting."; exit 1; }
    pkg install -y git || handle_failure "git"
    pkg install -y chezmoi || handle_failure "chezmoi"
else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
fi

chezmoi "$@"
