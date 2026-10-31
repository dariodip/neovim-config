local ai = require("config.ai")

local has_opencode = vim.fn.executable("opencode") == 1

if ai.opencode and not has_opencode and not vim.g._opencode_missing_warned then
  vim.g._opencode_missing_warned = true
  vim.notify(
    "NVIM_PROFILE selects OpenCode, but the opencode executable is not on PATH",
    vim.log.levels.WARN,
    { title = "OpenCode" }
  )
end

---@type snacks.terminal.Opts
local terminal_opts = {
  win = {
    position = "right",
    enter = false,
  },
}

return {
  "nickjvandyke/opencode.nvim",
  enabled = ai.opencode and has_opencode,
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      server = {
        start = function()
          require("snacks.terminal").open("opencode", terminal_opts)
        end,
      },
    }

    local opencode = require("opencode")

    vim.keymap.set({ "n", "x" }, "<leader>aa", function()
      opencode.ask("@this: ")
    end, { desc = "Ask OpenCode" })

    vim.keymap.set({ "n", "x" }, "<leader>as", function()
      opencode.select()
    end, { desc = "Select OpenCode action" })

    vim.keymap.set({ "n", "x" }, "<leader>at", function()
      return opencode.operator("@this")
    end, { desc = "Send range to OpenCode", expr = true })

    vim.keymap.set("n", "<leader>ao", function()
      require("snacks.terminal").toggle("opencode", terminal_opts)
    end, { desc = "Toggle OpenCode terminal" })
  end,
}
