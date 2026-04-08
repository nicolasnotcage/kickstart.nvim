#!/usr/bin/env bash
# =============================================================================
# kickstart.nvim — Dedicated Linux Server (SSH) Setup
# =============================================================================
#
# TARGET ENVIRONMENT
#   Freshly installed Ubuntu Server, accessed via SSH from Windows Terminal.
#   No display server. No GUI. No snap.
#
# FONTS
#   Nerd Font rendering happens in your Windows Terminal on the client side.
#   No font installation is needed on the server.
#
# CLIPBOARD
#   win32yank and xclip/xsel don't work over SSH on a headless server.
#   Instead, use Neovim's built-in OSC 52 support (Neovim 0.10+), which
#   tunnels clipboard operations through the SSH connection to Windows
#   Terminal's clipboard — no binary required.
#
#   Add this to your init.lua (or kickstart.nvim's options section):
#
#     vim.g.clipboard = {
#       name  = 'OSC 52',
#       copy  = {
#         ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
#         ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
#       },
#       paste = {
#         ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
#         ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
#       },
#     }
#
#   Windows Terminal supports OSC 52 out of the box. Make sure
#   "Copy on Select" isn't fighting it, but otherwise it just works.
#
# TMUX + CLIPBOARD NOTE
#   If you run Neovim inside tmux, OSC 52 passthrough must be enabled or
#   tmux will swallow the escape sequence. Add to ~/.tmux.conf:
#
#     set -g allow-passthrough on
#     set -ag terminal-overrides ',*:Ms=\E]52;%p1%s;%p2%s\007'
#
#   This script writes those lines into ~/.tmux.conf automatically.
#
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# System packages
# -----------------------------------------------------------------------------

sudo apt update && sudo apt upgrade -y
sudo apt install -y \
    ripgrep \
    fd-find \
    unzip \
    curl \
    git \
    build-essential \
    tmux

# fd-find installs as 'fdfind' on Ubuntu; symlink to 'fd' for tool compatibility
# (telescope, etc. expect plain 'fd' on PATH)
if ! command -v fd &>/dev/null && command -v fdfind &>/dev/null; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    export PATH="$HOME/.local/bin:$PATH"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

# -----------------------------------------------------------------------------
# Node.js (LTS) via NodeSource
# -----------------------------------------------------------------------------

curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs

echo "Node version: $(node --version)"
echo "npm  version: $(npm --version)"

mkdir -p "$HOME/.npm-global"
npm config set prefix "$HOME/.npm-global"
export PATH="$HOME/.npm-global/bin:$PATH"
echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> ~/.bashrc

# tree-sitter-cli: install via npm to get the current release.
# The apt package (if available) often lags significantly behind.
npm install -g tree-sitter-cli

# -----------------------------------------------------------------------------
# Neovim (upstream tarball)
# -----------------------------------------------------------------------------
# Snap is excluded deliberately. On a headless server snap confinement
# prevents nvim from seeing binaries in non-standard PATH locations
# (e.g. ~/.npm-global/bin), which breaks treesitter parser compilation
# and LSP tool discovery. The tarball installs cleanly to /opt.

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo mkdir -p /opt/nvim-linux-x86_64
sudo chmod a+rX /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
rm nvim-linux-x86_64.tar.gz

echo "Neovim version: $(nvim --version | head -1)"

# -----------------------------------------------------------------------------
# tmux configuration
# -----------------------------------------------------------------------------
# Writes a base ~/.tmux.conf. If one already exists it is left untouched
# (a .new file is written instead so you can review and merge manually).

TMUX_CONF="$HOME/.tmux.conf"
TMUX_CONF_NEW="$HOME/.tmux.conf.new"

TMUX_CONF_CONTENT='# =============================================================
# tmux.conf — base config for SSH dev on headless Linux server
# =============================================================

# Remap prefix from C-b to C-a (screen-style; easier on home row)
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Use 256-color + true-color passthrough; lets Neovim render themes correctly
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB"

# OSC 52 clipboard passthrough — required for Neovim clipboard over SSH
set -g allow-passthrough on
set -ag terminal-overrides ",*:Ms=\E]52;%p1%s;%p2%s\007"

# Start window and pane numbering at 1 (easier to reach on keyboard)
set -g base-index 1
setw -g pane-base-index 1

# Renumber windows automatically when one is closed
set -g renumber-windows on

# Increase scrollback buffer
set -g history-limit 10000

# Reduce escape-key delay (important for Neovim)
set -sg escape-time 10

# Enable mouse (scroll, click to select pane/window)
set -g mouse on

# Intuitive pane splits (open in current directory)
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
unbind '"'
unbind %

# Reload config without restarting tmux
bind r source-file ~/.tmux.conf \; display "tmux.conf reloaded"

# Status bar
set -g status-style "bg=#1e1e2e,fg=#cdd6f4"
set -g status-left " #S "
set -g status-right " %H:%M  %Y-%m-%d "
setw -g window-status-current-style "fg=#89b4fa,bold"
'

if [[ -f "$TMUX_CONF" ]]; then
    echo ""
    echo "WARNING: ~/.tmux.conf already exists. Writing to ~/.tmux.conf.new instead."
    echo "Review it and merge manually."
    echo "$TMUX_CONF_CONTENT" > "$TMUX_CONF_NEW"
else
    echo "$TMUX_CONF_CONTENT" > "$TMUX_CONF"
    echo "Wrote ~/.tmux.conf"
fi

# -----------------------------------------------------------------------------
# kickstart.nvim
# -----------------------------------------------------------------------------

git clone https://github.com/nicolasnotcage/kickstart.nvim.git \
    "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------

echo ""
echo "================================================================"
echo " Setup complete."
echo "================================================================"
echo ""
echo " Next steps:"
echo "   1. Source your updated PATH:  source ~/.bashrc"
echo "   2. Launch nvim to trigger the initial plugin install."
echo "   3. Add the OSC 52 clipboard block to your init.lua"
echo "      (see comments at the top of this script)."
echo "   4. Start a tmux session:  tmux new -s main"
echo ""
echo " Neovim: $(nvim --version | head -1)"
echo " tmux:   $(tmux -V)"
echo " Node:   $(node --version)"
