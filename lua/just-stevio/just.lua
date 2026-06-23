local config = require("just-stevio.config")
local M = {}

function M.recipes()
	local result = vim.system({ config.options.executable, "--dump", "--dump-format", "json" }, { text = true }):wait()

	if result.code ~= 0 then
		vim.notify("just failed: " .. result.stderr, vim.log.levels.ERROR)
		return {}
	end

	local data = vim.json.decode(result.stdout, { luanil = { object = true, array = true } })

	local recipes = {}
	for name, recipe in pairs(data.recipes) do
		if not recipe.private then
			table.insert(recipes, {
				name = name,
				doc = recipe.doc,
				params = recipe.parameters,
			})
		end
	end
	return recipes
end

return M
