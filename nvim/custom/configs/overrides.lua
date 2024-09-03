local M = {}
local on_attach = require("plugins.configs.lspconfig").on_attach

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "markdown",
    "markdown_inline",
    "go",
    "python",
    "html",
    "css",
    "javascript",
    "sql",
    "docker",
    "yaml",
    "json",
    "c",
    "typescript",
    "tsx",
    "latex",
    "make",
    "dockerfile",
    "gitignore",
    "tailwindcss",
    "rust",
    "toml",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- python stuff
    "pyright",
    "flake8", -- linter: other popular linters - mypy, yapf, ruff
    "black",
    "isort",
    "debugpy",

    -- go stuff
    "gopls",
    "gofumpt",
    "golines",

    -- JSON stuff
    "json-lsp",

    -- YAML stuff
    "yaml-language-server",

    -- Web stuff
    "html-lsp",
    "css-lsp",
    "typescript-language-server",
    "angular-language-server",
    "eslint_d",
    "tailwindcss-language-server",

    -- SQL stuff
    "sqlls",

    -- Markdown
    "marksman",

    -- Docker stuff
    "docker-compose-language-service",
    "dockerfile-language-server",

    -- LaTeX
    "ltex-ls",

    -- Rust
    "rust-analyzer",
    -- using rust.vim and rustaceanvim plugins
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

-- rustaceanvim setup
M.rustaceanvim = {
  server = { on_attach = on_attach },
  default_settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      }
    }
  },
}

return M
