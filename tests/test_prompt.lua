local prompt = require("just-stevio.prompt")
local eq = MiniTest.expect.equality

local function collect_with(params, answers)
	local queue = vim.deepcopy(answers)
	local original = vim.ui.input
	vim.ui.input = function(_, on_confirm)
		on_confirm(table.remove(queue, 1))
	end

	local result = "DONE_NOT_CALLED"
	prompt.collect(params, function(args)
		result = args
	end)
	vim.ui.input = original
	return result
end

local T = MiniTest.new_set({
	hooks = {
		pre_case = function()
			notify_orig = vim.notify
			vim.notify = function() end
		end,
		post_case = function()
			vim.notify = notify_orig
		end,
	},
})

T["collects a single value"] = function()
	eq(collect_with({ { name = "name", kind = "singular" } }, { "world" }), { "world" })
end

T["empty input with a default appends nothing"] = function()
	eq(collect_with({ { name = "env", kind = "singular", default = "staging" } }, { "" }), {})
end

T["splits a variadic value into multiple args"] = function()
	eq(collect_with({ { name = "flags", kind = "plus" } }, { "-x -y  -z" }), { "-x", "-y", "-z" })
end

T["re-prompts when a required value is empty"] = function()
	eq(collect_with({ { name = "name", kind = "singular" } }, { "", "finally" }), { "finally" })
end

T["star param accepts empty without re-prompting"] = function()
	eq(collect_with({ { name = "opt", kind = "star" } }, { "" }), {})
end

T["esc cancels without calling done"] = function()
	eq(collect_with({ { name = "name", kind = "singular" } }, {}), "DONE_NOT_CALLED")
end

return T
