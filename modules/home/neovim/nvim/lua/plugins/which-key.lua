return {
	{
		"folke/which-key.nvim",
		enabled = true,
		event = "VeryLazy",
		opts = {
			delay = 500,
			sort = {"alphanum"},
			spec = {
				{ "<leader>b", desc = "[b]uffer" },
				{ "<leader>c", desc = "[c]ode" },
				{ "<leader>d", desc = "[d]irectory" },
				{ "<leader>f", desc = "[f]ile" },
				{ "<leader>s", desc = "[s]earch" },
				{ "<leader>w", desc = "[w]indow" },
				{ "<leader>t", desc = "[t]erminal" },
				{ "<leader>o", desc = "[o]rgmode" },
			}
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	}
}
