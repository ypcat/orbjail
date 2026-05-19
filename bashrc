if [ -f "$HOME/.local/bin/mise" ]; then
  export PATH="$HOME/.local/bin:$PATH"
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
  export ERL_AFLAGS="-kernel shell_history enabled"
  export IEX_HISTORY=enabled
  export LESS="-R"
  export EDITOR=nvim
  export VISUAL=nvim
  alias vim="nvim"
  alias jq="jaq"
  alias claude="CLAUDE_CODE_OAUTH_TOKEN=`cat ~/.claude/.token` claude --dangerously-skip-permissions"
  alias cat="bat --style=plain"
  alias ls="eza --icons --git"
  . <(mise activate bash)
  . <(fzf --bash)
  . <(gh completion -s bash)
  . <(starship init bash)
  . <(uv generate-shell-completion bash)
  . <(xh --generate=complete-bash)
  . <(zoxide init bash)
fi
