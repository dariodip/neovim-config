local ai = require("config.ai")

-- Read the global opt-in once and cache it. Changing the setting requires a
-- restart (documented in docs/customization.md), so there is no need to shell
-- out for every buffer that attaches.
local enabled ---@type boolean?
local function is_enabled()
  if enabled == nil then
    local result = vim.fn.system({
      "git",
      "config",
      "--global",
      "--type=bool",
      "--get",
      "copilot.enabled",
    })

    enabled = vim.v.shell_error == 0 and vim.trim(result) == "true"
  end

  return enabled
end

return {
  {
    "zbirenbaum/copilot.lua",
    enabled = ai.copilot,
    opts = {
      should_attach = function(bufnr)
        return ai.copilot and is_enabled() and vim.bo[bufnr].buflisted and vim.bo[bufnr].buftype == ""
      end,
    },
  },
  {
    -- LazyVim only adds this source when vim.g.ai_cmp is true. Keep a disabled
    -- spec so lazy-lock.json stays stable when the personal profile is active.
    "fang2hou/blink-copilot",
    enabled = ai.copilot,
  },
}
