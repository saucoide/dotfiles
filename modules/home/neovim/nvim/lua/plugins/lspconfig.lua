return {
	{
		"neovim/nvim-lspconfig",
		enabled = true,
		config = function()
			vim.lsp.enable({
				"rust_analyzer",
				"ty",
				"ruff",
				"lua_ls",
				"nixd",
			})
		end,
	},
}
