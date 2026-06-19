local M = {}

function M.run(recipe_name, args)
	vim.cmd("botright 15split")

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(0, buf)

	local cmd = { "just", recipe_name }
	vim.list_extend(cmd, args or {})

	vim.fn.jobstart(cmd, { term = true })
end

return M
