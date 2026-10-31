local ai = require("config.ai")

return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.keymap = opts.keymap or {}
    -- Keeps standard mappings but allows us to override individual keys
    opts.keymap.preset = "enter"

    -- Map Tab to accept the active completion item
    opts.keymap["<Tab>"] = { "accept", "fallback" }

    -- Disable Return/Enter from executing or confirming completions
    opts.keymap["<CR>"] = { "fallback" }

    -- Preview the selected suggestion even when Copilot is not driving Blink
    opts.completion = opts.completion or {}
    opts.completion.ghost_text = { enabled = true }

    if ai.deepseek then
      opts.sources = opts.sources or {}
      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.minuet = {
        name = "minuet",
        module = "minuet.blink",
        async = true,
        timeout_ms = 2500,
        score_offset = 8,
      }

      opts.sources.default = opts.sources.default or {}
      if not vim.tbl_contains(opts.sources.default, "minuet") then
        table.insert(opts.sources.default, "minuet")
      end

      -- Avoid asking DeepSeek before the user has typed anything
      opts.completion.trigger = opts.completion.trigger or {}
      opts.completion.trigger.prefetch_on_insert = false
    end
  end,
}
