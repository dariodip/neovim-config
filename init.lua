-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.opt.clipboard = "unnamedplus"
vim.keymap.set("v", "<D-c>", '"+y"', { noremap = true, silent = true })
