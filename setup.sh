#!/bin/bash
set -e

sudo apt update
sudo apt install -y git build-essential libncurses-dev libssl-dev inotify-tools autoconf m4
curl -fsSL https://mise.run/bash | bash
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"
mise use -g -j 1 bat btop claude fd fzf gh jaq jnv neovim rg starship tmux usage uv xh zoxide erlang@28 elixir@1.19

cat <<'EOF' >> .bashrc
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
EOF

mkdir -p ~/.local/share/nvim/site/parser ~/.config/nvim/queries/elixir
git clone https://github.com/elixir-lang/tree-sitter-elixir
cd tree-sitter-elixir
make
mv libtree-sitter-elixir.so ~/.local/share/nvim/site/parser/elixir.so
cp queries/* ~/.config/nvim/queries/elixir/
cd
rm -rf tree-sitter-elixir

cat <<'EOF' > ~/.config/nvim/init.lua
vim.cmd("filetype plugin indent on")
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"elixir", "heex", "eex"},
  callback = function() pcall(vim.treesitter.start) end
})
vim.pack.add({"https://github.com/echasnovski/mini.completion"})
require('mini.completion').setup({
  delay = { completion = 100, info = 100 },
  window = { info = { border = 'single' } }
})
vim.pack.add({"https://github.com/junegunn/fzf", "https://github.com/junegunn/fzf.vim"})
osc52 = require('vim.ui.clipboard.osc52')
vim.g.clipboard = {
  name = 'OSC 52',
  copy = { ['+'] = osc52.copy('+'), ['*'] = osc52.copy('*'), },
  paste = { ['+'] = osc52.paste('+'), ['*'] = osc52.paste('*'), },
}
vim.api.nvim_create_autocmd('BufReadPost', {pattern='*', command='normal `"'})
vim.keymap.set({'n', 'i'}, '<s-cr>', '<esc>:w<cr>:term time `readlink -f %`<cr>')
vim.keymap.set('n', '<c-c>', ':bd<cr>')
vim.keymap.set('n', '<c-p>', ':FZF<cr>')
vim.keymap.set('n', '<tab>', ':Buffers<cr>')
vim.o.autoindent = true
vim.o.autowrite = true
vim.o.clipboard = "unnamed,unnamedplus"
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.mouse = ""
vim.o.shiftwidth = 2
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.wrap = false
EOF
nvim --headless -c "lua vim.pack.update()" -c "qa"

cat <<'EOF' > ~/.tmux.conf
set -g prefix C-a
unbind-key C-b
bind-key C-a send-prefix
set -s escape-time 10
set -g default-terminal "tmux-256color"
set-option -ga terminal-overrides ",xterm-ghostty:Tc"
set-option -ga terminal-overrides ",xterm-ghostty:RGB"
set -as terminal-overrides ',xterm-ghostty:Smulx=\E[4::%p1%dm'
set -as terminal-overrides ',xterm-ghostty:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d;m'
set -g focus-events on
set -g allow-passthrough on
set -s set-clipboard on
set-window-option -g mode-keys vi
bind-key -T copy-mode-vi 'v' send-keys -X begin-selection
bind-key -T copy-mode-vi 'y' send-keys -X copy-selection-and-cancel
bind c new-window -c "#{pane_current_path}"
bind '"' split-window -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"
set -g status-left ''
set -g status-right ''
set -g status-style bg=colour208
set-option -g set-titles on
set-option -g set-titles-string "#h"
set-option -g history-limit 25000
set -g automatic-rename on
set -g status-interval 5
set -g automatic-rename-format '#(PROG="#{pane_current_command}"; GIT_DIR=$(git -C #{pane_current_path} rev-parse --show-toplevel 2>/dev/null); if [ "$PROG" != "bash" ] && [ "$PROG" != "zsh" ] && [ "$PROG" != "sh" ]; then echo "$PROG"; elif [ -n "$GIT_DIR" ]; then basename "$GIT_DIR"; else basename "#{pane_current_path}"; fi)'
EOF

git config --global user.email "claude@anthropic.com"
git config --global user.name "claude"
cat github_token | gh auth login --with-token
rm github_token
gh auth setup-git
gh auth status

rm -rf ~/.claude.json
mkdir -p ~/.claude
mv claude_token ~/.claude/.token
echo '{"apiKeyHelper":"cat ~/.claude/.token","skipDangerousModePermissionPrompt":true}' >  ~/.claude/settings.json
echo '{"hasCompletedOnboarding":true}' > ~/.claude.json
chmod 700 ~/.claude
chmod 600 ~/.claude/.token
claude auth status
