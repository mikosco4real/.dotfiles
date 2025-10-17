-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local servers = {
    "html",
    "cssls",
    "phpactor",
    "pyright",
    "gopls",
    "vuels",
    "yamlls",
    "dockerls",
    "tailwindcss",
    "pasls",
    "nginx_language_server",
    "markdown_oxide",
    "ltex",
    "jsonls",
    "docker_compose_language_service",
    "rust_analyzer",
}

vim.lsp.enable(servers)

-- to configure lsps further read :h vim.lsp.config
