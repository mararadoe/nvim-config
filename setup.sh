#!/bin/bash
# NeoVim IDE setup for remote servers
# Usage: curl -sL <raw-url>/setup.sh | bash
#    or: ssh server 'bash -s' < setup.sh

set -e

NVIM_VERSION="v0.11.6"
REPO="git@github.com:YOUR_USER/nvim-config.git"  # ← 自分のリポジトリに変更

echo "==> Installing NeoVim ${NVIM_VERSION}..."
mkdir -p ~/bin
curl -sLo ~/bin/nvim "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.appimage"
chmod u+x ~/bin/nvim

# Add to PATH if not already
if ! grep -q 'HOME/bin' ~/.bashrc 2>/dev/null; then
  echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
fi
export PATH="$HOME/bin:$PATH"

echo "==> Cloning nvim config..."
if [ -d ~/.config/nvim/.git ]; then
  cd ~/.config/nvim && git pull
else
  rm -rf ~/.config/nvim
  git clone "$REPO" ~/.config/nvim
fi

echo "==> Installing plugins..."
nvim --headless "+Lazy! sync" +qa 2>/dev/null || true

echo "==> Installing tree-sitter-cli..."
if command -v npm &>/dev/null; then
  npm install -g tree-sitter-cli 2>/dev/null || true
fi

echo "==> Installing fd..."
if ! command -v fd &>/dev/null; then
  FD_VERSION="10.2.0"
  curl -sLo /tmp/fd.tar.gz "https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd-v${FD_VERSION}-x86_64-unknown-linux-musl.tar.gz"
  tar xzf /tmp/fd.tar.gz -C /tmp
  cp "/tmp/fd-v${FD_VERSION}-x86_64-unknown-linux-musl/fd" ~/bin/
  rm -rf /tmp/fd.tar.gz /tmp/fd-v${FD_VERSION}-x86_64-unknown-linux-musl
fi

echo "==> Done! Restart your shell or run: source ~/.bashrc"
