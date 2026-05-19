#!/bin/bash
set -e
trap 'rm -f ~/github_token' EXIT
# apt
sudo apt update
sudo apt install -y git build-essential libncurses-dev libssl-dev inotify-tools autoconf m4
# mise
curl -fsSL https://mise.run/bash | bash
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"
export GITHUB_TOKEN=$(cat ~/github_token)
mise use -g bat btop claude fd fzf gh jaq jnv neovim rg starship tmux usage uv xh zoxide erlang@28 elixir@1.19
. ~/.bashrc
# elixir tree sitter
git clone -b v0.3.5 --depth 1 https://github.com/elixir-lang/tree-sitter-elixir
cd tree-sitter-elixir
make
mv libtree-sitter-elixir.so ~/.local/share/nvim/site/parser/elixir.so
cp queries/* ~/.config/nvim/queries/elixir/
cd
rm -rf tree-sitter-elixir
# nvim
nvim --headless -c "lua vim.pack.update()" -c "qa"
# gh
echo "$GITHUB_TOKEN" | gh auth login --with-token
gh auth setup-git
gh auth status
# claude
chmod 700 ~/.claude
chmod 600 ~/.claude/.token
claude auth status
# end
echo 'orbjail ready'
rm setup.sh
