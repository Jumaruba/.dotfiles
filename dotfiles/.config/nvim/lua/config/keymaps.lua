-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<leader>e", "<cmd>Explore<cr>", { desc = "File explorer" })
-- <leader>h is left free as the harpoon prefix; <Esc> and <leader>ur already
-- clear hlsearch.
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- buffers
map("n", "<leader>gt", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>Gt", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bk", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- System clipboard
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })

-- GIT
map("n", "<leader>gdo", "<cmd>DiffviewOpen<cr>", { desc = "Git Diffview open" })
map("n", "<leader>gdc", "<cmd>DiffviewClose<cr>", { desc = "Git Diffview close" })
map("n", "<leader>gdh", "<cmd>DiffviewFileHistory<cr>", { desc = "Git Diffview file history" })
map("n", "<leader>gdr", "<cmd>DiffviewRefresh<cr>", { desc = "Git Diffview refresh" })

-- ctags navigation
map("n", "md", "<C-]>", { desc = "Jump to tag definition" })
map("n", "mt", "<C-t>", { desc = "Jump back from tag" })
