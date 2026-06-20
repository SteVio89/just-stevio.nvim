local child = MiniTest.new_child_neovim()
local eq = MiniTest.expect.equality

local T = MiniTest.new_set({
	hooks = {
		pre_case = function()
			child.restart({ "-u", "tests/minimal_init.lua" })
			child.o.lines, child.o.columns = 12, 50
		end,
		post_once = function()
			child.stop()
		end,
	},
})

T["register the :Just command"] = function()
	eq(child.lua_get([[vim.fn.exists(":Just")]]), 2)
end

T["real input flow collects the typed value"] = function()
	child.lua_notify([[
    require("just-stevio.prompt").collect(
      { { name = "name", kind = "singular" } },
      function(args) _G.collected = args end
    )
  ]])
	child.type_keys("world", "<CR>")
	eq(child.lua_get("_G.collected"), { "world" })
end

T["prompt shows the parameter name and default"] = function()
	child.lua_notify([[
    require("just-stevio.prompt").collect(
      { { name = "env", kind = "singular", default = "staging" } },
      function() end
    )
  ]])
	MiniTest.expect.reference_screenshot(child.get_screenshot())
	child.type_keys("<CR>")
end

return T
