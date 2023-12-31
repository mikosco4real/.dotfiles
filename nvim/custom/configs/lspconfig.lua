local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local util = require("lspconfig/util")

local common_servers = {
	"tailwindcss",
	"cssls",
	"jsonls",
	"tsserver",
	"sqlls",
	"dockerls",
	"marksman",
	"docker_compose_language_service",
	"angularls",
}

for _, lsp in ipairs(common_servers) do
	lspconfig[lsp].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})
end

lspconfig.gopls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_dir = util.root_pattern("go.work", "go.mod", ".git"),
	settings = {
		gopls = {
			completeUnimported = true,
			usePlaceholders = true,
			analyses = {
				unusedparams = true,
			},
		},
	},
})

-- Python setup
lspconfig.pyright.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Rust setup
lspconfig.rust_analyzer.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "rust" },
	root_dir = util.root_pattern("Cargo.toml"),
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
			},
		},
	},
})

-- SQL setup
lspconfig.sqlls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "sql", "psql", "mysql" },
	root_dir = util.root_pattern(".git", ".env"),
})

-- Configure Lua
lspconfig.lua_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	autostart = true,
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
		},
	},
})

-- Configure html
local cp = vim.lsp.protocol.make_client_capabilities()
cp.textDocument.completion.completionItem.snippetSupport = true

lspconfig.html.setup({
	on_attach = on_attach,
	capabilities = cp,
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html" },
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = {
			css = true,
			javascript = true,
		},
		provideFormatter = true,
	},
	root_dir = util.root_pattern(".git", ".env", "*.html"),
	settings = {},
	single_file_support = true,
	opts = {
		settings = {
			html = {
				format = {
					templating = true,
					wrapLineLength = 120,
					wrapAttributes = "auto",
				},
				hover = {
					documention = true,
					references = true,
				},
			},
		},
	},
})
