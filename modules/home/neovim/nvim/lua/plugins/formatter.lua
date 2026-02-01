return {
	{
		'mhartington/formatter.nvim',
		enabled = true,
		event = "VeryLazy",
		config = function()
			require("formatter").setup({
				logging = true,
				filetype = {
					lua = { require("formatter.filetypes.lua").stylua },
					nix = { require("formatter.filetypes.nix").nixfmt },
					python = { function()
						return {
							exe = "ruff",
							args = {"format", "-q", "-"},
							stdin = true,
						}
					end
					},
					terraform = { require("formatter.filetypes.terraform").terraformfmt },
					toml = { require("formatter.filetypes.toml").taplo },
					yaml = {
						function()
							return {
								exe = "yamlfmt",
								args = { "-in", "-formatter", "retain_line_breaks_single=true"},
								stdin = true,
							}
						end
					},
					json = { require("formatter.filetypes.json").jq },
					rust = { require("formatter.filetypes.rust").rustfmt },
					c = { require("formatter.filetypes.c").clangformat },
					["*"] = { require("formatter.filetypes.any").remove_trailing_whitespace }
				}
			}
			)
		end
	}
}
