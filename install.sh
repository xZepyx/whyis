#!/bin/sh
set -eu

REPO_URL="https://github.com/xZepyx/whyis.git"
TMP_DIR="/tmp/whyis-install"
BIN_NAME="whyis"
TARGET="/usr/bin/$BIN_NAME"

printf "Do you want to install whyis? (y/N): "

if ! read -r ans </dev/tty; then
  echo "Aborted."
  exit 1
fi

case "$ans" in
  y|Y) ;;
  *)
    echo "Aborted."
    exit 0
    ;;
esac


echo "==> Preparing temporary directory"
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

echo "==> Cloning repository"
git clone "$REPO_URL" "$TMP_DIR"

cd "$TMP_DIR"

echo "==> Checking for Nim"
if ! command -v nim >/dev/null 2>&1; then
  echo "Nim is not installed."
  echo "Please install Nim first:"
  echo "  https://nim-lang.org/install.html"
  exit 1
fi

NIM_BIN="$(command -v nim)"

echo "==> Compiling whyis"
"$NIM_BIN" c -d:release whyis.nim

if [ ! -f "$BIN_NAME" ]; then
  echo "Build failed: binary not found"
  exit 1
fi

echo "==> Installing to $TARGET"
sudo mv "$BIN_NAME" "$TARGET"
sudo chmod +x "$TARGET"

echo "==> Cleaning up"
cd /
rm -rf "$TMP_DIR"

echo "==> whyis installed successfully"
echo "Run: whyis \"wifi slow\""
