local just = require("just-stevio.just")
local runner = require("just-stevio.runner")
local prompt = require("just-stevio.prompt")
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
				local recipe = by_display[selected[1]]
				if recipe.params and #recipe.params > 0 then
					prompt.collect(recipe.params, function(args)
						runner.run(recipe.name, args)
					end)
				else
					runner.run(recipe.name)
				end
			end,
		},
	})
end

return M
