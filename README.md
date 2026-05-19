# orbjail

Provision an isolated OrbStack Ubuntu VM as a full Elixir/Claude dev environment.

Claude runs inside with `--dangerously-skip-permissions` — free to read, write, and execute anything in the VM — while the host stays untouched.

Pair with **[orbwall](https://github.com/ypcat/orbwall/)** for network-level isolation: a macOS menu bar firewall that intercepts every TCP connection the VM makes and prompts Allow/Block per domain.

## Prerequisites

- [OrbStack](https://orbstack.dev)
- [Ghostty](https://ghostty.org) terminal (for terminfo)
- `GITHUB_TOKEN` — GitHub personal access token
- `CLAUDE_TOKEN` — Claude API key

## Usage

```bash
./create.sh
```

Tears down any existing `ubuntu` orb, creates a fresh isolated one, and provisions it (~10 min). SSH in with `ssh orb` or open a shell with `orb shell`.

Set `GITHUB_TOKEN` and `CLAUDE_TOKEN` in your environment beforehand, or `create.sh` will prompt for them.

## What's inside

| Category | Tools |
|---|---|
| Languages | Elixir 1.19, Erlang/OTP 28 |
| Editor | Neovim with Elixir treesitter, mini.completion, fzf.vim |
| Shell | bash, starship, fzf, zoxide |
| CLI | gh, bat, ripgrep, fd, btop, jaq, jnv, uv, xh |
| Multiplexer | tmux (prefix: C-a) |
| Auth | GitHub CLI, Claude Code |
