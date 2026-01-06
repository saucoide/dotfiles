return {
	{
		'stevearc/oil.nvim',
		enabled = true,
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			buf_options = { buflisted = true },
			cleanup_delay_ms = 5000,
			columns = { "permissions", "size", { "mtime", format = "%Y-%m-%d %H:%M" }, "icon" },
			constrain_cursor = "editable",
			default_file_explorer = true,
			delete_to_trash = true,
			keymaps = {
				["<CR>"] = "actions.select",
				["<S-CR>"] = "actions.select_vsplit",
				["<leader>oe"] = "actions.open_external",
				["<left>"] = "actions.parent",
				["<right>"] = "actions.select",
				H = "actions.toggle_hidden",
				cd = "actions.cd",
				gr = "actions.refresh",
				h = "actions.parent",
				l = "actions.select",
				q = "actions.close",
			},
			skip_confirm_for_simple_edits = false,
			use_default_keymaps = false,
			view_options = { show_hidden = false },
			watch_for_changes = false,
			win_options = {
				concealcursor = "nvic",
				conceallevel = 3,
				cursorcolumn = false,
				foldcolumn = "0",
				list = false,
				signcolumn = "no",
				spell = false,
				wrap = false,
			},
		},
		-- Optional dependencies
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		lazy = false, -- lazy loading not recommended from upstream
	}
}
