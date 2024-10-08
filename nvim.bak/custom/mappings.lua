---@type MappingsTable
local M = {}

M.general = {
	n = {
		[";"] = { ":", "enter command mode", opts = { nowait = true } },
	},
}

-- more keybinds!

M.nvterm = {
	plugin = true,

	t = {
		-- toggle in terminal mode
		["ƒ"] = {
			function()
				require("nvterm.terminal").toggle("float")
			end,
			"Toggle floating term",
		},

		["˙"] = {
			function()
				require("nvterm.terminal").toggle("horizontal")
			end,
			"Toggle horizontal term",
		},

		["√"] = {
			function()
				require("nvterm.terminal").toggle("vertical")
			end,
			"Toggle vertical term",
		},
	},

	n = {
		-- toggle in normal mode
		["ƒ"] = {
			function()
				require("nvterm.terminal").toggle("float")
			end,
			"Toggle floating term",
		},

		["˙"] = {
			function()
				require("nvterm.terminal").toggle("horizontal")
			end,
			"Toggle horizontal term",
		},

		["√"] = {
			function()
				require("nvterm.terminal").toggle("vertical")
			end,
			"Toggle vertical term",
		},

		-- new
		["<leader>h"] = {
			function()
				require("nvterm.terminal").new("horizontal")
			end,
			"New horizontal term",
		},

		["<leader>v"] = {
			function()
				require("nvterm.terminal").new("vertical")
			end,
			"New vertical term",
		},
	},
}

M.dap = {
	plugin = true,
	n = {
		["<leader>db"] = { "<cmd> DapToggleBreakpoint <CR>" },
	},
}

M.dap_python = {
	plugin = true,
	n = {
		["<leader>dpr"] = {
			function()
				require("dap-python").test_method()
			end,
		},
	},
}

return M
