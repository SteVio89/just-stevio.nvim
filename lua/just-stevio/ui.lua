local just = require("just-stevio.just")
local runner = require("just-stevio.runner")
local fzf = require("fzf-lua")

local M = {}

function M.pick()
	local recipes = just.recipes()

	local entries = {}
	local by_display = {}
	for _, recipe in ipairs(recipes) do
		local display = recipe.name
		if recipe.doc then
			display = display .. " - " .. recipe.doc
		end
		table.insert(entries, display)
		by_display[display] = recipe
	end

	fzf.fzf_exec(entries, {
		prompt = "just> ",
		actions = {
			["default"] = function(selected)
				vim.notify("selected = " .. vim.inspect(selected))
				local recipe = by_display[selected[1]]
				vim.notify("recipe = " .. vim.inspect(recipe))
				runner.run(recipe.name)
			end,
		},
	})
end

return M
