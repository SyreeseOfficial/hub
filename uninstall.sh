#!/bin/bash
# Removes the launcher entry. Then delete this folder if you want it fully gone.
rm -f ~/.local/share/applications/hub.desktop && echo "Removed. (rm -rf $(dirname "$(readlink -f "$0")") to delete the rest)"
