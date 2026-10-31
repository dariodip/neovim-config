-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Use the system clipboard for yanks, deletes, and pastes.
-- This intentionally overrides LazyVim's SSH-aware clipboard default.
vim.opt.clipboard = "unnamedplus"

-- Route the active profile's AI suggestions into Blink. Copilot is only added
-- to Blink when the work profile is active; see lua/config/ai.lua.
vim.g.ai_cmp = require("config.ai").copilot
