# just-stevio.nvim

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

## Configuration

There is none yet. The `:Just` command and the `<leader>j` mapping are registered automatically. If you want a different key, map it yourself and skip the default:

```lua
vim.keymap.set("n", "<leader>r", "<cmd>Just<cr>", { desc = "Run a just recipe" })
```

## Limitations

- Recipes run as `just <name>` with no extra arguments. Recipes whose parameters have defaults will use them; recipes with required parameters will fail until argument support is added.
- The output split is a plain terminal buffer. Closing and reusing it is left to you for now.

## License

MIT. See [LICENSE](LICENSE).
