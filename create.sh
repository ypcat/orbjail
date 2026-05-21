#!/bin/bash
set -e
cd `dirname $0`
[ -z "$GITHUB_TOKEN" ] && read -p 'enter GITHUB_TOKEN:' GITHUB_TOKEN
[ -z "$CLAUDE_TOKEN" ] && read -p 'enter CLAUDE_TOKEN:' CLAUDE_TOKEN
ORB=orb
orb delete -f ubuntu || true
orb create ubuntu:resolute --isolated
infocmp -x xterm-ghostty | ssh orb -- "tic -x - 2>/dev/null"
rsync -avz setup $ORB:
echo "$GITHUB_TOKEN" | orb bash -c 'cat > setup/github_token'
echo "$CLAUDE_TOKEN" | orb bash -c 'cat > setup/claude_token'
orb ./setup/setup.sh
