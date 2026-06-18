local M = {}

function M.recipes()
	local result = vim.system({ "just", "--dump", "--dump-format", "json" }, { text = true }):wait()

	if result.code ~= 0 then
		vim.notify("just failed: " .. result.stderr, vim.log.levels.ERROR)
		return {}
	end

	local data = vim.json.decode(result.stdout, { luanil = { object = true, array = true } })

	local recipes = {}
	for name, recipe in pairs(data.recipes) do
		table.insert(recipes, {
			name = name,
			doc = recipe.doc,
			params = recipe.parameters,
		})
	end
	return recipes
end

return M
