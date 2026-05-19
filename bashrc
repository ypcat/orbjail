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
  alias claude="claude --dangerously-skip-permissions"
  alias cat="bat --style=plain"
  . <(mise activate bash)
  . <(fzf --bash)
  . <(gh completion -s bash)
  . <(starship init bash)
  . <(uv generate-shell-completion bash)
  . <(xh --generate=complete-bash)
  . <(zoxide init bash)
fi
