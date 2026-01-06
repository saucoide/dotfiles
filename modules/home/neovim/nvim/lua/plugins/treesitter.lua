return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = 'master',
		enabled = true,
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				incremental_selection = { enable = false }, -- TODO whats this
				indent = { enable = true },
			})
		end
	}
}
