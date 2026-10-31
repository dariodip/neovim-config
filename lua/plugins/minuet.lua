local ai = require("config.ai")

if ai.minuet and not ai.deepseek and not vim.g._minuet_missing_key_warned then
  vim.g._minuet_missing_key_warned = true
  vim.notify(
    "NVIM_PROFILE selects DeepSeek completion, but DEEPSEEK_API_KEY is not set",
    vim.log.levels.WARN,
    { title = "DeepSeek" }
  )
end

return {
  "milanglacier/minuet-ai.nvim",
  enabled = ai.deepseek,
  config = function()
    require("minuet").setup({
      provider = "openai_fim_compatible",
      provider_options = {
        openai_fim_compatible = {
          -- DeepSeek V4.1 Flash uses the deepseek-flash model ID. FIM completion
          -- is only available through the beta /completions endpoint.
          model = "deepseek-flash",
          end_point = "https://api.deepseek.com/beta/completions",
          api_key = "DEEPSEEK_API_KEY",
          name = "DeepSeek",
          stream = true,
          optional = {
            max_tokens = 256,
            top_p = 0.9,
            stop = { "\n\n" },
          },
        },
      },
      request_timeout = 2.5,
      throttle = 1000,
      debounce = 400,
      n_completions = 1,
    })
  end,
}
