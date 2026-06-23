# just-stevio.nvim

![tests](https://github.com/SteVio89/just-stevio.nvim/actions/workflows/test.yml/badge.svg)

Run [just](https://github.com/casey/just) recipes from inside Neovim. It reads the recipes from your justfile, lets you pick one with a fuzzy finder, and runs it in a terminal split so you can watch the output live.

It exists because my usual workflow is a terminal split below the editor where I type `just run`, `just test`, `just build` over and over. This keeps that workflow but skips the typing and the context switch.

## Requirements

- Neovim 0.12 or newer
- The [`just`](https://github.com/casey/just) command line tool, available on your `PATH`
- [fzf-lua](https://github.com/ibhagwan/fzf-lua) for the picker

## Installation

With Neovim's built-in plugin manager (`vim.pack`):

```lua
vim.pack.add({
  { src = "https://github.com/ibhagwan/fzf-lua", name = "fzf" },
  { src = "https://github.com/SteVio89/just-stevio.nvim", name = "just-stevio"},
})
```

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "SteVio89/just-stevio.nvim",
  dependencies = { "ibhagwan/fzf-lua" },
}
```

## Usage

Open a project that has a `justfile` and run `:Just`. To open the picker with a key, set `keymaps.open` (see Configuration).

A fuzzy list of the recipes appears, each shown with its doc comment (the `#` line above the recipe). Pick one and it runs in a terminal split (at the bottom of the window by default).

If the recipe takes parameters, you are asked for each one before it runs. The prompt shows the parameter name and, when it has a default, that default in parentheses. Leave a parameter blank to fall back to its default; a required parameter is asked again until you give it a value. Variadic parameters (`+` and `*`) accept several values separated by spaces on the one line. Press `<Esc>` at any prompt to cancel without running.

The split is a real terminal, so a recipe that asks for input works, just type your answer while it runs. Once the recipe finishes the split stays open in normal mode so you can scroll back through the output; press `q` to close it.

## Configuration

The `:Just` command works without any setup. Call `setup` to override the defaults, every key is optional:

```lua
require("just-stevio").setup({
  executable = "just",          -- the just binary to run
  window = {
    position = "botright",      -- where the output split opens
    size = 15,                  -- its height in lines (width in columns for a vertical split)
  },
  picker = {
    prompt = "just> ",          -- prompt shown in the fuzzy finder
  },
  keymaps = {
    open = nil,                 -- key that opens the picker; unset means no mapping
    close = "q",                -- key that closes the output split
  },
})
```

With lazy.nvim you can pass the same table as `opts`:

```lua
{
  "SteVio89/just-stevio.nvim",
  dependencies = { "ibhagwan/fzf-lua" },
  opts = {
    keymaps = { open = "<leader>j" },
  },
}
```

`position` accepts any Vim split modifier, for example `"vertical botright"` for a full-height panel on the right.

## Limitations

- Parameter values are split on whitespace, so a single variadic value cannot itself contain a space.
- Each run opens its own split; there is no single window that gets reused.

## License

MIT. See [LICENSE](LICENSE).
