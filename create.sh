#!/bin/bash
[ -z $GITHUB_TOKEN ] && echo 'export GITHUB_TOKEN=... missing' && exit 1
[ -z $CLAUDE_TOKEN ] && echo 'export CLAUDE_TOKEN=... missing' && exit 1
orb delete -f ubuntu
orb create ubuntu:resolute --isolated
infocmp -x xterm-ghostty | ssh orb -- tic -x -
scp setup.sh orb:
orb bash -c 'echo '$GITHUB_TOKEN' > github_token'
orb bash -c 'echo '$CLAUDE_TOKEN' > claude_token'
orb ./setup.sh
