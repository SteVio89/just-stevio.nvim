deps_dir := "deps"

test: deps
  nvim --headless --noplugin -i NONE -u tests/minimal_init.lua -c "lua MiniTest.run()" -c "qall"

deps: (_clone "echasnovski/mini.nvim" "mini.nvim") (_clone "ibhagwan/fzf-lua" "fzf-lua")

_clone repo name:
      #!/usr/bin/env sh
      set -eu
      target="{{deps_dir}}/{{name}}"
      if [ ! -e "$target" ]; then
          echo "cloning {{repo}} -> $target"
          git clone --filter=blob:none --depth 1 "https://github.com/{{repo}}" "$target"
      fi

