#!/bin/bash
set -e
bold_cyan='\033[1;36m'
reset='\033[0m'
section() { echo -e "${bold_cyan}# $1${reset}"; }
section '📦 installing apt packages'
sudo apt update
sudo apt install -yq git build-essential libncurses-dev libssl-dev inotify-tools autoconf m4 man file
section '🔧 installing mise packages'
curl -fsSL https://mise.run/bash | bash
export GITHUB_TOKEN=$(cat ~/setup/github_token)
cat ~/setup/mise_packages | xargs ~/.local/bin/mise use -g
section '🐚 setting up bash'
mv ~/setup/bashrc ~/.bashrc
. ~/.bashrc
section '🖥️  setting up tmux'
mv ~/setup/tmux.conf ~/.tmux.conf
section '🌳 setting up elixir tree sitter'
cd setup
git clone -b v0.3.5 --depth 1 https://github.com/elixir-lang/tree-sitter-elixir
cd tree-sitter-elixir
make
mkdir -p ~/.local/share/nvim/site/parser ~/.config/nvim/queries/elixir
mv libtree-sitter-elixir.so ~/.local/share/nvim/site/parser/elixir.so
cp queries/* ~/.config/nvim/queries/elixir/
cd ~
section '✏️  setting up nvim'
mv ~/setup/nvim_init.lua ~/.config/nvim/init.lua
nvim --headless -c "lua vim.pack.update()" -c "qa"
section '🐙 setting up github'
unset GITHUB_TOKEN
gh auth login --with-token < ~/setup/github_token
gh auth setup-git
gh auth status
git config --global user.name "claude"
git config --global user.email "claude@anthropic.com"
section '🤖 installing claude'
curl -fsSL https://claude.ai/install.sh | bash
mkdir -p ~/.claude
mv ~/setup/claude.json ~/.claude.json
mv ~/setup/claude.md ~/.claude/CLAUDE.md
mv ~/setup/claude_settings.json ~/.claude/settings.json
mv ~/setup/claude_statusline_command.sh ~/.claude/statusline-command.sh
mv ~/setup/claude_token ~/.claude/.token
chmod 700 ~/.claude
chmod 600 ~/.claude/.token
claude auth status
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
rtk init -g
section '🚀 installing antigravity'
curl -fsSL https://antigravity.google/cli/install.sh | bash
rm -rf ~/setup
section '🔒 orbjail ready'
