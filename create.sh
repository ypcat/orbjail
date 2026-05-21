#!/bin/bash
set -e
cd `dirname $0`
[ -z "$GITHUB_TOKEN" ] && read -p 'enter GITHUB_TOKEN:' GITHUB_TOKEN
[ -z "$CLAUDE_TOKEN" ] && read -p 'enter CLAUDE_TOKEN:' CLAUDE_TOKEN
ORB=orb
orb delete -f ubuntu
orb create ubuntu:resolute --isolated
infocmp -x xterm-ghostty | ssh orb -- "tic -x - 2>/dev/null"
rsync -avz setup $ORB:
#scp setup.sh $ORB:
#orb mkdir -p .claude .local/share/nvim/site/parser .config/nvim/queries/elixir
#scp bashrc $ORB:~/.bashrc
#scp nvim_init.lua $ORB:~/.config/nvim/init.lua
#scp tmux.conf $ORB:~/.tmux.conf
#scp claude_settings.json $ORB:~/.claude/settings.json
#scp claude.json $ORB:~/.claude.json
#echo "$GITHUB_TOKEN" | orb bash -c 'cat > github_token'
#echo "$CLAUDE_TOKEN" | orb bash -c 'cat > ~/.claude/.token'
#ssh $ORB 'cat > ~/.gitconfig' <<EOF
#[user]
#	email = $(git config user.email)
#	name = $(git config user.name)
#EOF
#orb ./setup.sh
echo "$GITHUB_TOKEN" | orb bash -c 'cat > setup/github_token'
echo "$CLAUDE_TOKEN" | orb bash -c 'cat > setup/claude_token'
orb ./setup/setup.sh
