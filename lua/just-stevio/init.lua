local M = {}

function M.pick()
	require("just-stevio.ui").pick()
end

function M.setup(opts)
	require("just-stevio.config").setup(opts)
end

return M
