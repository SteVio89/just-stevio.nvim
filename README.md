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
  "stevio/just-stevio.nvim",
  dependencies = { "ibhagwan/fzf-lua" },
}
```

## Usage

Open a project that has a `justfile`, then either:

- press `<leader>j`, or
- run `:Just`

A fuzzy list of the recipes appears, each shown with its doc comment (the `#` line above the recipe). Pick one and it runs in a terminal split at the bottom of the window.

If the recipe takes parameters, you are asked for each one before it runs. The prompt shows the parameter name and, when it has a default, that default in parentheses. Leave a parameter blank to fall back to its default; a required parameter is asked again until you give it a value. Variadic parameters (`+` and `*`) accept several values separated by spaces on the one line. Press `<Esc>` at any prompt to cancel without running.

## Configuration

There is none yet. The `:Just` command and the `<leader>j` mapping are registered automatically. If you want a different key, map it yourself and skip the default:

```lua
vim.keymap.set("n", "<leader>r", "<cmd>Just<cr>", { desc = "Run a just recipe" })
```

## Limitations

- Parameter values are split on whitespace, so a single variadic value cannot itself contain a space.
- The output split is a plain terminal buffer. Closing and reusing it is left to you for now.

## License

MIT. See [LICENSE](LICENSE).
