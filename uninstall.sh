#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="${INSTALL_DIR:-$HOME/.supervisor-secretvault}"
TARGET_BIN="${1:-$HOME/.local/bin}"

echo "Removing supervisor-secretvault binary link..."
rm -f "$TARGET_BIN/supervisor-secretvault"

if [ -d "$INSTALL_DIR" ]; then
    echo "Warning: This will delete the entire vault including secrets, grants, and audit logs."
    read -p "Are you sure you want to delete $INSTALL_DIR? [y/N] " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        rm -rf "$INSTALL_DIR"
        echo "Removed repository directory $INSTALL_DIR"
    else
        echo "Kept repository directory $INSTALL_DIR"
    fi
fi

echo "Uninstall complete."
