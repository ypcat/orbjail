#!/bin/bash
set -e
# apt
sudo apt update
sudo apt install -y git build-essential libncurses-dev libssl-dev inotify-tools autoconf m4 man file
# mise
curl -fsSL https://mise.run/bash | bash
export GITHUB_TOKEN=$(cat ~/setup/github_token)
cat ~/setup/mise_packages | xargs ~/.local/bin/mise use -g
# bash
mv ~/setup/bashrc ~/.bashrc
. ~/.bashrc
# tmux
mv ~/setup/tmux.conf ~/.tmux.conf
# elixir tree sitter
cd setup
git clone -b v0.3.5 --depth 1 https://github.com/elixir-lang/tree-sitter-elixir
cd tree-sitter-elixir
make
mkdir -p ~/.local/share/nvim/site/parser ~/.config/nvim/queries/elixir
mv libtree-sitter-elixir.so ~/.local/share/nvim/site/parser/elixir.so
cp queries/* ~/.config/nvim/queries/elixir/
cd ~
# nvim
mv ~/setup/nvim_init.lua ~/.config/nvim/init.lua
nvim --headless -c "lua vim.pack.update()" -c "qa"
# gh
unset GITHUB_TOKEN
gh auth login --with-token < ~/setup/github_token
gh auth setup-git
gh auth status
git config --global user.name "claude"
git config --global user.email "claude@anthropic.com"
# claude
curl -fsSL https://claude.ai/install.sh | bash
mkdir -p ~/.claude
mv ~/setup/claude_settings.json ~/.claude/settings.json
mv ~/setup/claude_token ~/.claude/.token
mv ~/setup/claude.json ~/.claude.json
chmod 700 ~/.claude
chmod 600 ~/.claude/.token
claude auth status
# end
rm -rf ~/setup
echo 'orbjail ready'
