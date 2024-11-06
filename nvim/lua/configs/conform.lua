local options = {
    formatters_by_ft = {
        lua = { "stylua" },
        css = { "prettierd" },
        html = { "prettierd" },
        vue = { "prettierd", lsp_format = "fallback" },
        ts = { "prettierd", "eslint_d" },
        json = { "jd" },
        yaml = { "yamlfmt", "yamllint" },
        yml = { "yamlfmt", "yamllint" },
    },

    format_on_save = {
        --   -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
    },
}

return options
