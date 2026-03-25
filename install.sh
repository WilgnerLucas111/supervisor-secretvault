#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${VAULT_REPO_URL:-https://github.com/joustonhuang/supervisor-secretvault.git}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.supervisor-secretvault}"
TARGET_BIN="${1:-$HOME/.local/bin}"

echo "Using repository: $REPO_URL"

echo "Installing supervisor-secretvault to $INSTALL_DIR..."

if [ -d "$INSTALL_DIR" ]; then
    echo "Directory exists, checking repository state..."
    cd "$INSTALL_DIR"
    
    # Check if it's a valid git repo
    if [ -d ".git" ] && git remote get-url origin 2>/dev/null | grep -q "$REPO_URL"; then
        echo "Valid repository found. Updating..."
        git checkout main
        git fetch origin
        git reset --hard origin/main
    else
        echo "Directory is not the correct repository or is corrupted. Re-cloning..."
        cd /
        rm -rf "$INSTALL_DIR"
        git clone "$REPO_URL" "$INSTALL_DIR"
        cd "$INSTALL_DIR"
    fi
else
    echo "Cloning repository..."
    git clone "$REPO_URL" "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

echo "Setting permissions..."
mkdir -p "$TARGET_BIN"
mkdir -p "$INSTALL_DIR/secrets" "$INSTALL_DIR/grants" "$INSTALL_DIR/audit" "$INSTALL_DIR/config" "$INSTALL_DIR/tmp"
chmod 700 "$INSTALL_DIR/secrets" "$INSTALL_DIR/grants" "$INSTALL_DIR/audit" "$INSTALL_DIR/config" "$INSTALL_DIR/tmp" 2>/dev/null || true

echo "Creating binary link..."
ln -sf "$INSTALL_DIR/src/cli.js" "$TARGET_BIN/supervisor-secretvault"
chmod +x "$INSTALL_DIR/src/cli.js"

echo "Installed supervisor-secretvault -> $TARGET_BIN/supervisor-secretvault"
echo "Export SECRETVAULT_MASTER_KEY before use."
