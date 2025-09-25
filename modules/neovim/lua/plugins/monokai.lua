return {
	{
		'saucoide/monokai-pro.nvim',
		branch = "mynokai",
		lazy = false,
		priority = 1000,
		enabled = true,
		config = function()
			require("monokai-pro").setup({
				devicons = true,
				terminal_colors = true,
				filter = "pro",
			})
			vim.cmd([[colorscheme monokai-pro]])
		end,
	}
}
