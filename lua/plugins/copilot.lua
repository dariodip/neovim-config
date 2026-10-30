return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      should_attach = function(bufnr)
        if not vim.bo[bufnr].buflisted or vim.bo[bufnr].buftype ~= "" then
          return false
        end
        local result = vim.fn.system({
          "git",
          "config",
          "--global",
          "--type=bool",
          "--get",
          "copilot.enabled",
        })

        return vim.v.shell_error == 0 and vim.trim(result) == "true"
      end,
    },
  },
}
