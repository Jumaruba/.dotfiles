-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- JSON indents with 2 spaces instead of the global 4 (see init.lua), and never
-- formats on save -- conform has no json formatter, so LazyVim would otherwise
-- fall back to jsonls' LSP formatting. `<leader>cf` still formats on demand.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("json_indent", { clear = true }),
  pattern = { "json", "jsonc", "json5" },
  callback = function(args)
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
    vim.b[args.buf].autoformat = false
  end,
})

