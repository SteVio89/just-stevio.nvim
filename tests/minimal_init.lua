local root = vim.uv.cwd()

vim.cmd("set runtimepath^=" .. vim.fn.fnameescape(root))

for _, dep in ipairs({ "mini.nvim", "fzf-lua" }) do
	vim.cmd("set runtimepath^=" .. vim.fn.fnameescape(root .. "/deps/" .. dep))
end

require("mini.test").setup()
