local M = {}

M.defaults = {
	executable = "just",
	window = {
		position = "botright",
		size = 15,
	},
	picker = {
		prompt = "just> ",
	},
	keymaps = {
		open = nil,
		close = "q",
	},
}

M.options = vim.deepcopy(M.defaults)

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})

	if type(M.options.window.size) ~= "number" or M.options.window.size <= 0 then
		vim.notify("just-stevio: window.size must be a positive number", vim.log.levels.WARN)
		M.options.window.size = M.defaults.window.size
	end
	if type(M.options.window.position) ~= "string" then
		vim.notify("just-stevio: window.position must be a string", vim.log.levels.WARN)
		M.options.window.position = M.defaults.window.position
	end
	if type(M.options.executable) ~= "string" then
		vim.notify("just-stevio: executable must be a string", vim.log.levels.WARN)
		M.options.executable = M.defaults.executable
	end

	if M.options.keymaps.open then
		vim.keymap.set("n", M.options.keymaps.open, function()
			require("just-stevio").pick()
		end, { desc = "Just: pick and run a recipe" })
	end
end

return M
