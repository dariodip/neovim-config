-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Copy the current visual selection to the system clipboard.
vim.keymap.set("v", "<D-c>", '"+y', { noremap = true, silent = true, desc = "Copy to system clipboard" })
