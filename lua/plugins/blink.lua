return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      -- Keeps standard mappings but allows us to override individual keys
      preset = "enter",

      -- Map Tab to accept the active completion item
      ["<Tab>"] = { "accept", "fallback" },

      -- Disable Return/Enter from executing or confirming completions
      ["<CR>"] = { "fallback" },
    },
  },
}
