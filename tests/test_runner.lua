local runner = require("just-stevio.runner")
local eq = MiniTest.expect.equality

local function captured_cmd(name, args)
	local original = vim.fn.jobstart
	local got
	vim.fn.jobstart = function(cmd, _opts)
		got = cmd
		return 1
	end
	runner.run(name, args)
	vim.fn.jobstart = original
	return got
end

local T = MiniTest.new_set({
	hooks = {
		post_case = function()
			pcall(vim.cmd, "only")
		end,
	},
})

T["runs a bare recipe with no extra args"] = function()
	eq(captured_cmd("clean"), { "just", "clean" })
end

T["appends collected args after the recipe name"] = function()
	eq(captured_cmd("deploy", { "prod", "v2" }), { "just", "deploy", "prod", "v2" })
end

T["an explicit empty arg list add nothing"] = function()
	eq(captured_cmd("build", {}), { "just", "build" })
end

return T
