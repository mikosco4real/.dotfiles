# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Personal dotfiles managed with **GNU Stow**. There is no build step and no test suite — edits to files in this repo take effect on the host the moment Stow's symlinks are in place.

## Stow layout

Each top-level directory is a Stow *package*. Its contents mirror `$HOME`, so running `stow <pkg>` from this directory symlinks the files into the correct location.

```
~/.dotfiles/<pkg>/<relative-path-under-HOME>  →  ~/<relative-path-under-HOME>
```

Examples:
- `zshrc/.zshrc` → `~/.zshrc`
- `nvim/.config/nvim/init.lua` → `~/.config/nvim/init.lua`
- `tmux/.tmux.conf` → `~/.tmux.conf`

Common commands (run from `~/.dotfiles`):
- `stow <pkg>` — link a package into `$HOME`
- `stow -R <pkg>` — re-stow after adding/removing files
- `stow -D <pkg>` — unlink

`.stow-local-ignore` keeps `README*`, `LICENSE*`, and `.git` out of the link set even though they live inside a package directory. Add to it when introducing files that should stay in-repo but never be symlinked.

`zshrc/` and `zed/` are present on disk (and still managed by stow locally) but are **gitignored** while a cross-machine sync strategy is worked out — don't re-add them to tracking without checking with the user first.

When adding a **new** dotfile, place it under a package at the path it should occupy relative to `$HOME` (create the package directory if needed), then re-stow.

## Neovim package (`nvim/`) — non-obvious bits

This is the most substantive config in the repo. It is a **post-NvChad migration**: it dropped the NvChad meta-framework + `lazy.nvim`, but kept the NvChad *look* (chadracula-evondev theme, statusline, tabufline) by loading the `base46` and `ui` plugins directly. See `nvim/.config/nvim/README.md` for full migration notes.

Key constraints when editing nvim config:

- **`init.lua` step order is load-bearing.** `vim.pack.add()` must run before any `require()` of a plugin, and the `base46` highlight cache must exist before plugin configs `dofile()` it. Don't reorder the numbered steps without understanding why.
- **Per-plugin config lives in `lua/setup.lua` → `lua/configs/<plugin>.lua`.** `init.lua` calls `require("setup")` between `vim.pack.add` and `require("nvchad")`; `setup.lua` dispatches into the individual files under `lua/configs/`. Plugin `setup{}` tweaks belong there, not in `plugins.lua`.
- **No lazy-loading.** `vim.pack` (Neovim 0.12+) has no event/cmd/keys deferral and no `build` hooks. Anything that previously ran in a lazy.nvim `build` step is wired up explicitly after `vim.pack.add()` returns.
- **Treesitter is pinned to the `main` branch** in `lua/plugins.lua`. The old `master` branch has injection-query breakage on nvim 0.12. The `main` branch requires the `tree-sitter` CLI on PATH (`brew install tree-sitter-cli`) to compile parsers.
- **After changing the theme** in `lua/chadrc.lua`, run `:BuildHighlights` inside nvim, then restart. The user command is defined at the bottom of `init.lua` and rebuilds the base46 cache.
- **LSP servers** are enabled in `lua/lsp.lua` via `vim.lsp.enable({...})` using nvim 0.11+ APIs (not `lspconfig.setup`). Per-server defaults come from `nvim-lspconfig`'s `lsp/<server>.lua` files on the runtimepath; only override fields go in `vim.lsp.config(...)`.
- **Plugin updates** use `:Pack update` (replaces `:Lazy sync`); `:Pack` lists installed plugins. Mason packages update via `:Mason`.
- **Side-by-side testing.** To try config changes without disturbing the live config, launch with `NVIM_APPNAME=nvim-new nvim` — `vim.pack` clones plugins into `~/.local/share/nvim-new/` and the stowed `~/.config/nvim` symlink stays untouched. See `nvim/.config/nvim/README.md` for the full swap-in procedure.
- **Lock files** (`lazy-lock.json`, `nvim-pack-lock.json`) are gitignored at the repo root — don't commit them.

### Lua formatting

`.stylua.toml` (inside `nvim/.config/nvim/`) governs Lua style: 4-space indent, 120-column width, `AutoPreferDouble` quotes, `call_parentheses = "None"` (so `require "foo"` is preferred over `require("foo")` where stylua would rewrite). Run `stylua .` from the nvim config dir before committing Lua changes.

## Other packages — quick orientation

- **`starship/`** — single `starship.toml`. Invoked by `eval "$(starship init zsh)"` in `.zshrc`.
- **`tmux/`** — `.tmux.conf` plus `.tmux/scripts/setup-session.sh`. Uses tpm; **tpm must be installed manually** (`git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`) — it is not vendored. A `session-created` hook in `.tmux.conf` runs `setup-session.sh`, which builds a default dev layout (IDE→`nvim .`, GIT→`lazygit`, Terminal, Logs, Claude→`claude`) for every new session; same script is bound to `prefix + L` as a manual trigger. The script is idempotent (no-ops when the session already has >1 window). Editing either file requires `stow -R tmux` before the new symlinks take effect.
- **`kitty/`**, **`gitui/`** — terminal / git-TUI configs.
