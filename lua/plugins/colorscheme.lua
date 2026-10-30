return {
  -- Install gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000, -- Ensure it loads first
    config = function()
      -- Optional configuration
      require("gruvbox").setup({
        contrast = "hard", -- can be "hard", "soft" or empty string for medium
        transparent_mode = false,
      })
    end,
  },

  -- Configure LazyVim to use it as the default colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
