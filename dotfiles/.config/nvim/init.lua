require("config.lazy")
require("config.lualine")

-- Theme
vim.cmd.colorscheme("catppuccin-macchiato")

-- Set tab to 4 spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Show line numbers
vim.opt.number = true
vim.opt.relativenumber = false

-- Map leader
vim.opt.number = true
vim.opt.relativenumber = false

-- Avoid breaking up a word when breaking a line
vim.opt.linebreak = true

-- Metals configuration
vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }
