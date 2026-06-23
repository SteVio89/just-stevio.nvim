local config = require("just-stevio.config")
local M = {}

function M.run(recipe_name, args)
	vim.cmd(("%s %dsplit"):format(config.options.window.position, config.options.window.size))

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(0, buf)

	vim.keymap.set("n", config.options.keymaps.close, function()
		vim.api.nvim_buf_delete(buf, { force = true })
	end, { buffer = buf, nowait = true })

	local cmd = { config.options.executable, recipe_name }
	vim.list_extend(cmd, args or {})

	vim.fn.jobstart(cmd, {
		term = true,
		on_exit = function()
			vim.schedule(function()
				if vim.api.nvim_get_current_buf() ~= buf then
					return
				end
				local keys = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
				vim.api.nvim_feedkeys(keys, "n", false)
			end)
		end,
	})
end

return M
