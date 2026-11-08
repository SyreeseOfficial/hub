#!/bin/bash
# Adds "Hub" to the app launcher (one .desktop file). Undo with ./uninstall.sh
HUB=$(dirname "$(readlink -f "$0")")
chmod +x "$HUB/hub.sh" "$HUB/uninstall.sh"
cat > ~/.local/share/applications/hub.desktop <<D
[Desktop Entry]
Type=Application
Name=Hub
Comment=Launch my tools
Exec=$HUB/hub.sh
Icon=applications-development
Terminal=false
D
echo "Installed. Open the launcher and type: Hub"
