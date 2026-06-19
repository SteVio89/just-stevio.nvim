local M = {}

function M.collect(params, done)
	local args = {}

	local function ask(i)
		if i > #params then
			done(args)
			return
		end

		local p = params[i]
		local label = p.name
		if p.default then
			label = label .. " (" .. p.default .. ")"
		elseif p.kind == "plus" or p.kind == "star" then
			label = label .. " (space-separated)"
		end

		vim.ui.input({ prompt = label .. ": " }, function(value)
			if value == nil then
				return
			end

			local variadic = p.kind == "plus" or p.kind == "star"

			if value ~= "" then
				if variadic then
					vim.list_extend(args, vim.split(value, "%s+", { trimempty = true }))
				else
					table.insert(args, value)
				end
			elseif p.default == nil and p.kind ~= "star" then
				vim.notify(p.name .. " is required", vim.log.levels.WARN)
				return ask(i)
			end

			ask(i + 1)
		end)
	end
	ask(1)
end

return M
