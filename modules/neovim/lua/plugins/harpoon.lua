return {
	{
		'saucoide/harpoon',
		branch = "terminal-list",
		enabled = true,
		config = function()
			local harpoon = require("harpoon")
			harpoon.setup({
				settings = { save_on_toggle = true },
				["terms"] = require("harpoon.terms"):new()
			})
		end,
		keys = {
			-- harpoon
			{"<leader>a", function() require("harpoon"):list():add() end,  desc = "Harpoon: Add file" },
			{"<leader>hh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end,  desc = "Harpoon: Toggle quick menu" },
			{"<leader>1", function() require("harpoon"):list():select(1) end,  desc = "Harpoon: Go to file 1" },
			{"<leader>2", function() require("harpoon"):list():select(2) end,  desc = "Harpoon: Go to file 2" },
			{"<leader>3", function() require("harpoon"):list():select(3) end,  desc = "Harpoon: Go to file 3" },
			{"<leader>4", function() require("harpoon"):list():select(4) end,  desc = "Harpoon: Go to file 4" },
			{"<leader>5", function() require("harpoon"):list():select(5) end,  desc = "Harpoon: Go to file 5" },
			-- Terminals
			{"<leader>tt", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list("terms")) end, desc="Show harpoon terminal menu" },
			{"<leader><CR><CR>", function() require("harpoon"):list("terms"):select(1) end, desc="Harpoon: Go to Terminal 1" },
			{"<leader><CR>1", function() require("harpoon"):list("terms"):select(1) end, desc="Harpoon: Go to Terminal 1" },
			{"<leader><CR>2", function() require("harpoon"):list("terms"):select(2) end, desc="Harpoon: Go to Terminal 2" },
			{"<leader><CR>3", function() require("harpoon"):list("terms"):select(3) end, desc="Harpoon: Go to Terminal 3" },
			{"<leader><CR>4", function() require("harpoon"):list("terms"):select(4) end, desc="Harpoon: Go to Terminal 4" },
			{"<leader><CR>5", function() require("harpoon"):list("terms"):select(5) end, desc="Harpoon: Go to Terminal 5" },
			-- Terminal actions: clear
			{"<C-l>1", function() require("harpoon"):list("terms"):send_command(1, "clear") end, desc="Harpoon: Clear Terminal 1" },
			{"<C-l>2", function() require("harpoon"):list("terms"):send_command(2, "clear") end, desc="Harpoon: Clear Terminal 2" },
			{"<C-l>3", function() require("harpoon"):list("terms"):send_command(3, "clear") end, desc="Harpoon: Clear Terminal 3" },
			{"<C-l>4", function() require("harpoon"):list("terms"):send_command(4, "clear") end, desc="Harpoon: Clear Terminal 4" },
			{"<C-l>5", function() require("harpoon"):list("terms"):send_command(5, "clear") end, desc="Harpoon: Clear Terminal 5" },
			-- Terminal actions: send command
			{"<C-CR><CR>", function() require("harpoon"):list("terms"):send_selection(1, true) end, mode={"n", "v"}, desc="Harpoon: Current selection to Terminal 1" },
			{"<C-CR>1", function() require("harpoon"):list("terms"):send_selection(1, true) end, mode={"n", "v"}, desc="Harpoon: Current selection to Terminal 1" },
			{"<C-CR>2", function() require("harpoon"):list("terms"):send_selection(2, true) end, mode={"n", "v"}, desc="Harpoon: Current selection to Terminal 2" },
			{"<C-CR>3", function() require("harpoon"):list("terms"):send_selection(3, true) end, mode={"n", "v"}, desc="Harpoon: Current selection to Terminal 3" },
			{"<C-CR>4", function() require("harpoon"):list("terms"):send_selection(4, true) end, mode={"n", "v"}, desc="Harpoon: Current selection to Terminal 4" },
			{"<C-CR>5", function() require("harpoon"):list("terms"):send_selection(5, true) end, mode={"n", "v"}, desc="Harpoon: Current selection to Terminal 5" },
		}
	}
}
