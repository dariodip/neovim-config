return {
  -- Track coding time with WakaTime
  -- Requires the wakatime-cli binary (auto-installed to ~/.wakatime/ if missing)
  -- and an API key in ~/.wakatime.cfg
  {
    "wakatime/vim-wakatime",
    event = "VimEnter",
  },
}
