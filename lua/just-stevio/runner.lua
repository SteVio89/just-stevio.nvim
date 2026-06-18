local M = {}

function M.run(recipe_name)
	vim.cmd("botright 15split")

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(0, buf)

	vim.fn.jobstart({ "just", recipe_name }, { term = true })
end

return M
