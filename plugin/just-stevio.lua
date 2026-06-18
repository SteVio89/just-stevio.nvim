if vim.g.loaded_just_stevio then
	return
end
vim.g.loaded_just_stevio = true

vim.api.nvim_create_user_command("Just", function()
	require("just-stevio").pick()
end, { desc = "Pick and run a justfile recipe" })

vim.keymap.set("n", "<leader>j", function()
	require("just-stevio").pick()
end, { desc = "Just: pick and run a recipe" })
