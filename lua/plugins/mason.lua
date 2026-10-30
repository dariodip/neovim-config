return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      local seen = {}
      opts.ensure_installed = vim.tbl_filter(function(package)
        if seen[package] then
          return false
        end
        seen[package] = true
        return true
      end, opts.ensure_installed)
    end,
  },
}
