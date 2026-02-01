return {
	{
		"catgoose/nvim-colorizer.lua",
		enabled = true,
		event = "BufReadPre",
		opts = {
			filetypes = { "css", "nix" },
			user_default_options = {
				names = false,
			},
		},
	},
}
