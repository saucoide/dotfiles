return {
	{
		"chipsenkbeil/org-roam.nvim",
		tag = "0.2.0",
		enabled = true,
		event = "VeryLazy",
		dependencies = {
			{
				"nvim-orgmode/orgmode",
				tag = "0.7.0",
			},
		},
		config = function()
			require("org-roam").setup({
				directory = "~/notes/roam/",
				ui = {
					select = {
						---@type fun(node:org-roam.core.file.Node):org-roam.config.ui.SelectNodeItems
						node_to_items = function(node)
							---@type string[]
							local items = {}
							local function make_item(label)
								if #node.tags == 0 then
									-- We can pass a string if the label and value
									-- are the same
									return label
								else
									local tags = table.concat(node.tags, ":")
									-- In the case that the label (displayed) and
									-- value (injected) are different, we can pass
									-- a table with `label` and `value` back
									return {
										label = ("[%s] %s"):format(tags, label),
										value = label,
									}
								end
							end
							-- For the node's title and its aliases, we want
							-- to create an item where the title/alias is the
							-- value and we show them alongside tags if they exist
							--
							-- This allows us to search tags, but not insert
							-- tags as part of a link if selected
							table.insert(items, make_item(node.title))
							for _, alias in ipairs(node.aliases) do
								-- Avoid duplicating the title if the alias is the same
								if alias ~= node.title then
									table.insert(items, make_item(alias))
								end
							end
							return items
						end,
					},
				},
			}
			)
		end
	}
}
