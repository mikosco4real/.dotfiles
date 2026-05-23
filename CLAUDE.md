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

`.stow-local-ignore` keeps `README*`, `LICENSE*`, `.git`, and Zed's local-only state (`zed/conversations`, `zed/embeddings`, `zed/prompts`, `zed/themes`) out of the link set even though they live inside a package directory. Add to it when introducing files that should stay in-repo but never be symlinked.

When adding a **new** dotfile, place it under a package at the path it should occupy relative to `$HOME` (create the package directory if needed), then re-stow.

## Neovim package (`nvim/`) — non-obvious bits

This is the most substantive config in the repo. It is a **post-NvChad migration**: it dropped the NvChad meta-framework + `lazy.nvim`, but kept the NvChad *look* (chadracula-evondev theme, statusline, tabufline) by loading the `base46` and `ui` plugins directly. See `nvim/.config/nvim/README.md` for full migration notes.

Key constraints when editing nvim config:

- **`init.lua` step order is load-bearing.** `vim.pack.add()` must run before any `require()` of a plugin, and the `base46` highlight cache must exist before plugin configs `dofile()` it. Don't reorder the numbered steps without understanding why.
- **No lazy-loading.** `vim.pack` (Neovim 0.12+) has no event/cmd/keys deferral and no `build` hooks. Anything that previously ran in a lazy.nvim `build` step is wired up explicitly after `vim.pack.add()` returns.
- **Treesitter is pinned to the `main` branch** in `lua/plugins.lua`. The old `master` branch has injection-query breakage on nvim 0.12. The `main` branch requires the `tree-sitter` CLI on PATH (`brew install tree-sitter-cli`) to compile parsers.
- **After changing the theme** in `lua/chadrc.lua`, run `:BuildHighlights` inside nvim, then restart. The user command is defined at the bottom of `init.lua` and rebuilds the base46 cache.
- **LSP servers** are enabled in `lua/lsp.lua` via `vim.lsp.enable({...})` using nvim 0.11+ APIs (not `lspconfig.setup`). Per-server defaults come from `nvim-lspconfig`'s `lsp/<server>.lua` files on the runtimepath; only override fields go in `vim.lsp.config(...)`.
- **Lock files** (`lazy-lock.json`, `nvim-pack-lock.json`) are gitignored at the repo root — don't commit them.

### Lua formatting

`.stylua.toml` (inside `nvim/.config/nvim/`) governs Lua style: 4-space indent, 120-column width, `AutoPreferDouble` quotes, `call_parentheses = "None"` (so `require "foo"` is preferred over `require("foo")` where stylua would rewrite). Run `stylua .` from the nvim config dir before committing Lua changes.

## Other packages — quick orientation

- **`zshrc/`** — Oh My Zsh based. Inits pyenv, NVM, bun, Starship, and Laravel Herd's multi-version PHP env vars. When adding a tool that needs PATH/shims, add it here.
- **`starship/`** — single `starship.toml`. Invoked by `eval "$(starship init zsh)"` in `.zshrc`.
- **`tmux/`** — `.tmux.conf` only. Uses tpm; **tpm must be installed manually** (`git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`) — it is not vendored.
- **`kitty/`**, **`gitui/`**, **`zed/`** — terminal/editor configs. Zed's `conversations`, `embeddings`, `prompts`, and `themes` subdirs are intentionally excluded from stow (see `.stow-local-ignore`) because they are machine-local state, not config to share.
