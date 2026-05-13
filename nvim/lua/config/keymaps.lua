-- LazyVim auto-loads this on VeryLazy.
-- Default LazyVim keymaps: lua/lazyvim/config/keymaps.lua

vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("i", "<C-s>", "<Esc><cmd>w<CR>", { desc = "Save file" })
