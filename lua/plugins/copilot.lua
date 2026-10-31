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
    opts = {
      should_attach = function(bufnr)
        return is_enabled() and vim.bo[bufnr].buflisted and vim.bo[bufnr].buftype == ""
      end,
    },
  },
}
