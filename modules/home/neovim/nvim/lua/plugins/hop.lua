return {
	{
		'smoka7/hop.nvim',
		enabled = true,
		keys = {
			{"s", "<cmd>:HopPatternAC<cr>", desc="Hop forwards in buffer" },
			{"S", "<cmd>:HopPatternBC<cr>", desc="Hop backwards in buffer" }
		},
		config = function()
			require("hop").setup()
		end
	}
}
