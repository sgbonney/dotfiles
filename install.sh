#!/bin/bash

handle_failure() {
    if ! command -v "$1" &> /dev/null; then
        echo "Failed to install $1."
        exit 1
    fi
}

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || handle_failure "brew"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && brew install chezmoi
    handle_failure "chezmoi"
elif [[ "$OSTYPE" == *"android"* ]]; then
    pkg install -y git
    handle_failure "git"
    pkg install -y chezmoi
    handle_failure "chezmoi"
else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
fi

chezmoi "$@"
