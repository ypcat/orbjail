#!/bin/bash
set -e
cd `dirname $0`
bold_cyan='\033[1;36m'
reset='\033[0m'
section() { echo -e "${bold_cyan}# $1${reset}"; }
section '🔑 reading tokens'
[ -z "$GITHUB_TOKEN" ] && read -p 'export GITHUB_TOKEN=' GITHUB_TOKEN
[ -z "$CLAUDE_TOKEN" ] && read -p 'export CLAUDE_TOKEN=' CLAUDE_TOKEN
ORB=orb
section '🌐 creating orb'
orb delete -f ubuntu || true
orb create ubuntu:resolute --isolated
infocmp -x xterm-ghostty | ssh orb -- "tic -x - 2>/dev/null"
section '📂 copying setup files'
scp -rpC setup $ORB:.orbjail
echo "$GITHUB_TOKEN" | orb bash -c 'cat > .orbjail/github_token'
echo "$CLAUDE_TOKEN" | orb bash -c 'cat > .orbjail/claude_token'
section '⚙️  running setup'
orb .orbjail/setup.sh
