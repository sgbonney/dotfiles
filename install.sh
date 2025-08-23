#!/bin/bash

handle_failure() {
    echo "Failed to install $1"
    exit 1
}

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || handle_failure "Homebrew"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    brew install chezmoi || handle_failure "Chezmoi"
elif [[ "$OSTYPE" == *"android"* ]]; then
    pkg install -y git || handle_failure "Git"
    pkg install -y chezmoi || handle_failure "Chezmoi"
else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
fi

chezmoi "$@"
