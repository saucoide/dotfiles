vim.keymap.set("n","<leader>osi",
	function()
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		row = row - 1
		local lang = 'sh'
		local block = {
			'#+begin_src ' .. lang,
			'',
			'#+end_src',
		}
		vim.api.nvim_buf_set_lines(0, row, row, false, block)
		vim.api.nvim_win_set_cursor(0, { row + 2, 0 })
		vim.cmd("startinsert")
	end,
	{ desc = "Insert SourceCode Block"}
)
