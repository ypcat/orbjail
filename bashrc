[ -f "$HOME/.local/bin/mise" ] || exit 0
export EDITOR=nvim
export ERL_AFLAGS="-kernel shell_history enabled"
export IEX_HISTORY=enabled
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LESS="-R"
export PATH="$HOME/.local/bin:$PATH"
export VISUAL=nvim
alias agy="agy --dangerously-skip-permissions"
alias cat="bat --style=plain"
alias claude="CLAUDE_CODE_OAUTH_TOKEN=`cat ~/.claude/.token` claude --dangerously-skip-permissions"
alias jq="jaq"
alias ls="eza --icons --git"
alias vim="nvim"
. <(mise activate bash)
. <(fzf --bash)
. <(gh completion -s bash)
. <(starship init bash)
. <(uv generate-shell-completion bash)
. <(xh --generate=complete-bash)
. <(zoxide init bash)
