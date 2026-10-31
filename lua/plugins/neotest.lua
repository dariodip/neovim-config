return {
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "orjangj/neotest-ctest",
      "nvim-neotest/neotest-plenary",
    },
    opts = {
      adapters = {
        -- C/C++ tests registered with CTest (GoogleTest, Catch2, doctest).
        -- Debug individual tests through LazyVim's CodeLLDB setup.
        ["neotest-ctest"] = { dap_adapter = "codelldb" },
        -- Plenary/busted suites, typically for Neovim plugins.
        ["neotest-plenary"] = {},
      },
    },
  },
}
