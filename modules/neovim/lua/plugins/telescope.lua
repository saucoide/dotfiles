return {
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		enabled = true,
		dependencies = { 
			'nvim-lua/plenary.nvim',
			"nvim-telescope/telescope-ui-select.nvim",
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			telescope.setup({
			defaults = {
				mappings = {
					i = {
						["<CR>"] = actions.select_default + actions.center,
						["<S-CR>"] = actions.select_vertical
					},
					n = {
						["<CR>"] = actions.select_default + actions.center,
						["<S-CR>"] = actions.select_vertical
					}
				}
			},
			pickers = {
				buffers = { mappings = { i = { ["<C-d>"] = "delete_buffer" }, } },
				find_files = { hidden = true },
				live_grep = { hidden = true},
				current_buffer_fuzzy_find = { previewer = false };
			},
		})
		-- telescope.load_extension("fzf-native")
		telescope.load_extension("ui-select")
		end
	}
}
