local just = require("just-stevio.just")
local eq = MiniTest.expect.equality

local DUMP = [[
{
  "recipes": {
    "hello": {
      "name": "hello",
      "doc": "Greet someone",
      "parameters": [ { "name": "name", "default": null, "kind": "singular" } ],
      "private": false
    },
    "clean": {
      "name": "clean",
      "doc": null,
      "parameters": [],
      "private": false
    },
    "_hidden": {
      "name": "_hidden",
      "doc": null,
      "parameters": [],
      "private": true
    }
  }
}
]]

local function recipes_from(json, code)
	local original = vim.system
	vim.system = function(_, _)
		return {
			wait = function()
				return { code = code or 0, stdout = json or "", stderr = "boom" }
			end,
		}
	end
	local ok, result = pcall(just.recipes)
	vim.system = original
	if not ok then
		error(result)
	end
	return result
end

local function by_name(list)
	local m = {}
	for _, r in ipairs(list) do
		m[r.name] = r
	end
	return m
end

local notify_orig
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

T["returns one entry per recipe"] = function()
	eq(#recipes_from(DUMP), 2)
end

T["carries name, doc and params"] = function()
	local r = by_name(recipes_from(DUMP))
	eq(r.hello.name, "hello")
	eq(r.hello.doc, "Greet someone")
	eq(#r.hello.params, 1)
	eq(r.hello.params[1].name, "name")
	eq(r.hello.params[1].kind, "singular")
end

T["null doc decodes to nil, empty params to an empty table"] = function()
	local r = by_name(recipes_from(DUMP))
	eq(r.clean.doc, nil)
	eq(r.clean.params, {})
end

T["non-zero exit returns an empty list"] = function()
	eq(recipes_from("", 1), {})
end

T["excludes private recipes"] = function()
	local r = by_name(recipes_from(DUMP))
	eq(r.hidden, nil)
end

return T
