local M = {}

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
    "ruff",

    -- go stuff
    "gopls",
    "gofumpt",
    "golines",

    -- Web stuff
    "html-lsp",
    "json-lsp",
    "css-lsp",
    "typescript-language-server",

    -- SQL stuff
    "sqlls",

    -- Markdown
    "marksman",

    -- Docker stuff
    "docker-compose-language-service",
    "dockerfile-language-server",
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

return M
