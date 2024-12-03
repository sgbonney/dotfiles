{{ if eq .chezmoi.os "android" -}}
#!/bin/sh

echo "KeePassXC: Tools > Settings > SSH Agent set 'SSH_AUTH_SOCK override' to,"
echo /data/data/com.termux/files/home/.ssh/ssh_auth_sock
termux-x11 :1 -xstartup "keepassxc" &

{{- end }}
