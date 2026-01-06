return {
	{
		"hrsh7th/nvim-cmp",
		enabled = true,
		dependencies = {
			'neovim/nvim-lspconfig',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			-- 'hrsh7th/cmp-cmdline',
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				mapping = {
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-e>"] = cmp.mapping.close(),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
					["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "path" },
					{ name = "buffer" },
					{ name = "orgmode" },
					-- { name = "cmdline" },
				},
			})
		end
	}
}
