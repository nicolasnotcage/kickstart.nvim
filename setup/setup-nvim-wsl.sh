#!/usr/bin/env bash
# =============================================================================
# kickstart.nvim — WSL Setup
# =============================================================================
#
# PREREQUISITES
#
# Clipboard
#   kickstart.nvim requires a clipboard provider. On WSL, use win32yank.
#   Install it in PowerShell before running this script:
#
#     winget install equalsraf.win32yank
#
# Font
#   On native Linux: configure a Nerd Font in your terminal emulator.
#   On WSL: set the font in Windows Terminal → Ubuntu → Appearance.
#   No manual font installation needed for WSL.
#
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# System packages
# -----------------------------------------------------------------------------

sudo apt update && sudo apt upgrade -y
sudo apt-get install -y ripgrep fd-find fonts-noto-color-emoji unzip

# NOTE: The kickstart.nvim wiki suggests an alternative apt block using the
# neovim-ppa/unstable PPA. That approach installs xclip as the clipboard
# provider, which does not work correctly on WSL. Stick with win32yank
# (installed via winget above) and this script's approach instead.

# -----------------------------------------------------------------------------
# Node.js (LTS) via NodeSource
# -----------------------------------------------------------------------------
# Installs current LTS; adjust the setup_XX.x URL to pin a different major.

curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs

echo "Node version: $(node --version)"
echo "npm  version: $(npm --version)"

mkdir -p "$HOME/.npm-global"
npm config set prefix "$HOME/.npm-global"
export PATH="$HOME/.npm-global/bin:$PATH"
echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> ~/.bashrc

# tree-sitter-cli: install via npm to get the current release.
# The apt package (if available) often lags behind significantly.
npm install -g tree-sitter-cli

# -----------------------------------------------------------------------------
# Neovim
# -----------------------------------------------------------------------------
# Install from the upstream tarball rather than snap. Snap's confinement
# prevents nvim from seeing binaries in non-standard PATH locations (e.g.
# ~/.npm-global/bin), which breaks treesitter parser compilation and similar
# tools. The tarball installs to /opt with no confinement.

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo mkdir -p /opt/nvim-linux-x86_64
sudo chmod a+rX /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
rm nvim-linux-x86_64.tar.gz

echo "Neovim version: $(nvim --version | head -1)"

# -----------------------------------------------------------------------------
# kickstart.nvim
# -----------------------------------------------------------------------------

mkdir -p ~/nvim && cd ~/nvim
git clone https://github.com/nicolasnotcage/kickstart.nvim.git \
    "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

echo ""
echo "Done. Launch nvim to trigger the initial plugin install."