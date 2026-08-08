-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Set to false to disable auto format
vim.g.lazyvim_eslint_auto_format = false
vim.g.lazyvim_picker = "fzf"
-- Keep blink.cmp on the 1.x release line: its `main` branch is v2, which
-- requires `saghen/blink.lib` and isn't supported by LazyVim yet.
vim.g.lazyvim_blink_main = false

-- Python pair: basedpyright for types/hover, ruff for lint/format. Read by
-- lazyvim.plugins.extras.lang.python; their settings live in plugins/lsp.lua.
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"
