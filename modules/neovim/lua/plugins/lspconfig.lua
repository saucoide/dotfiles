 return {
	 {
		 "neovim/nvim-lspconfig",
		 enabled = true,
		 config = function()
			 vim.lsp.config("pylsp", {
				 settings = {
					 pylsp = {
						 plugins = {
							 mypy = {
								 enabled = true,
								 -- live_mode = false, -- set true if you want checks on every keystroke
								 -- strict = false,    -- set true if you want --strict
								 -- dmypy = false,     -- set true to use dmypy daemon
								 -- report_progress = true,
							 },
						 }
					 }
				 }
			 })
			 vim.lsp.enable(
				 {
					 "ty",
					 "ruff",
					 "lua_ls",
					 "nixd",
				 }
			 )

		 end
	 }
 }
