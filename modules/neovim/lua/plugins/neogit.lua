return {
	{
		"NeogitOrg/neogit",
		enabled = true,
		dependencies = {
			"nvim-lua/plenary.nvim",         -- required
			"sindrets/diffview.nvim",        -- optional - Diff integration
			-- Only one of these is needed.
			"nvim-telescope/telescope.nvim", -- optional
		},
		keys = {
			{"<leader>gg", "<cmd>Neogit<CR>", desc="open [g]it" }
		},
		opts = {
			disable_insert_on_commit = true,
			git_services = {
				["git.wrke.in"] = {
					pull_request = "https://git.wrke.in/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
					commit = "https://git.wrke.in/${owner}/${repository}/-/commit/${oid}",
					tree = "https://git.wrke.in/${owner}/${repository}/-/tree/${branch_name}?ref_type=heads",
				}
			},
			graph_style = "ascii",
			mappings = { popup = { F = "PullPopup", p = "PushPopup" } },
			sections = {
				rebase = { folded = true, hidden = false },
				recent = { folded = true, hidden = false },
				sequencer = { folded = false, hidden = false },
				staged = { folded = false, hidden = false },
				stashes = { folded = true, hidden = false },
				unmerged_pushRemote = { folded = false, hidden = false },
				unmerged_upstream = { folded = false, hidden = false },
				unpulled_pushRemote = { folded = true, hidden = false },
				unpulled_upstream = { folded = true, hidden = false },
				unstaged = { folded = false, hidden = false },
				untracked = { folded = false, hidden = false },
			},
		}
	}
}
