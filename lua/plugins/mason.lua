return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}

      -- Required by nvim-dap-python's debugpy-adapter.
      vim.list_extend(opts.ensure_installed, { "debugpy" })

      -- Rust and C/C++ extras both request package names that can overlap.
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
