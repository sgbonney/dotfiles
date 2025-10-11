#!/bin/sh

KDBX=$(find ~/ -path '**/20251004T115212--*' -print || find -L ~/ -path '**/20251004T115212--*' -print)

[ -f "$KDBX" ] && (command -v keepassxc >/dev/null 2>&1 || flatpak list --app | grep -q org.keepassxc.KeePassXC) && exit

if [ "$(uname -o)" = "GNU/Linux" ]; then
    if ! command -v flatpak >/dev/null 2>&1; then
        if command -v apt >/dev/null 2>&1; then
            sudo apt update -y && sudo apt install -y flatpak || { echo "Failed to install Flatpak."; exit 1; }
        else
            echo "Unsupported package manager. Please install Flatpak manually."
            exit 1
        fi
    fi

    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak remote-modify --no-filter --enable flathub
    flatpak install --system -y flathub org.keepassxc.KeePassXC || { echo "Failed to install KeePassXC."; exit 1; }

    mkdir -p ~/.local/bin/
    cp ~/.local/share/chezmoi/home/private_dot_local/bin/executable_keepassxc-cli ~/.local/bin/keepassxc-cli && chmod +x ~/.local/bin/keepassxc-cli
elif [ "$(uname -o)" = "Android" ]; then
    pkg update -y
    pkg install -y x11-repo
    pkg install -y termux-x11-nightly
    pkg install -y keepassxc || { echo "Failed to install KeePassXC."; exit 1; }
    ln -s /storage/emulated/0/.keepass ~/.keepass || { echo "Failed to create .keepass symbolic link."; exit 1; }
else
    echo "Unsupported operating system: $(uname -o)"
    exit 1
fi

while [ ! -f "$KDBX" ]; do
    echo "KeePassXC database not found."
    echo "Please copy your database."
    echo "Press Enter when done to continue."
    read -r
done
