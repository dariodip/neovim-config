-- Select the AI setup at startup with the NVIM_PROFILE environment variable.
--
--   work (default) - GitHub Copilot
--   personal       - OpenCode agent + DeepSeek completion
--   both           - Both, for testing
--
-- Defaulting to "work" keeps an unset variable on the existing setup and avoids
-- unexpected DeepSeek requests.
local M = {}

local raw = (vim.env.NVIM_PROFILE or "work"):lower()

local aliases = {
  work = "work",
  copilot = "work",
  personal = "personal",
  opencode = "personal",
  deepseek = "personal",
  both = "both",
}

local profile = aliases[raw]

if not profile then
  vim.notify(
    ("Unknown NVIM_PROFILE %q; falling back to work. Use work, personal, or both."):format(raw),
    vim.log.levels.WARN,
    { title = "AI profile" }
  )
  profile = "work"
end

M.profile = profile
M.copilot = profile == "work" or profile == "both"
M.opencode = profile == "personal" or profile == "both"
M.minuet = profile == "personal" or profile == "both"

local key = vim.env.DEEPSEEK_API_KEY
M.deepseek = M.minuet and key ~= nil and key ~= ""

return M
