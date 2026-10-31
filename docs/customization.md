# Customization

Keep changes in this configuration, not inside downloaded plugin directories.
LazyVim merges local specs with its defaults. See the upstream
[configuration guide](https://www.lazyvim.org/configuration).

## Options, keymaps, and autocmds

Use `lua/config/options.lua` for options that must be set before plugins load:

```lua
vim.opt.relativenumber = true
vim.opt.wrap = false
```

Use `lua/config/keymaps.lua` for mappings and `lua/config/autocmds.lua` for
autocommands. Check the which-key menu before assigning a shortcut to avoid
replacing one you use.

## Plugins and extras

Create a file under `lua/plugins/` returning a lazy.nvim spec. For example,
to set a formatter while retaining LazyVim's formatting integration:

```lua
return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
      },
    },
  },
}
```

Ensure the formatter is installed and inspect `:ConformInfo`. Do not replace
Conform's `config` function or configure its own `format_on_save`; LazyVim
manages format-on-save. To disable automatic formatting globally, set
`vim.g.autoformat = false` in `lua/config/options.lua`.

Use `:LazyExtras` to enable or disable language and feature extras, then restart.
Commit the resulting `lazyvim.json` and reviewed lockfile changes. The example
file `lua/plugins/example.lua` returns early, so its sample specs are inactive;
copy only the relevant spec into a new file.

## Theme

Edit `lua/plugins/colorscheme.lua` to change Gruvbox contrast/transparency or
replace its plugin and LazyVim `colorscheme` option together. Terminal fonts and
terminal-level transparency must be configured outside Neovim.

## AI profiles

`NVIM_PROFILE` selects the AI setup when Neovim starts. `lua/config/ai.lua` reads
it once and gates the plugin specs; changes require a restart.

| `NVIM_PROFILE` | Inline completion | OpenCode agent | Copilot |
| --- | --- | --- | --- |
| `work` (default) | Copilot through Blink | Disabled | Enabled, still gated by `copilot.enabled` |
| `personal` | DeepSeek through Blink | Enabled | Disabled |
| `both` | Copilot and DeepSeek | Enabled | Enabled |

An unset or unrecognized value falls back to `work`, which avoids unexpected
DeepSeek requests. Set the variable in the shell that launches Neovim:

```sh
# Personal machine
export NVIM_PROFILE=personal
export DEEPSEEK_API_KEY='...'

# Work machine
export NVIM_PROFILE=work
```

On macOS, applications launched from the Dock or Finder may not inherit your
shell profile. Launch Neovim from a terminal, or set the variables through
`launchctl` or your terminal's environment settings. Never commit API keys.

### OpenCode (personal)

OpenCode is loaded only for `personal` and `both`. It requires the `opencode`
executable on `PATH`; verify with `:checkhealth opencode`. OpenCode handles its
own authentication, which is separate from `DEEPSEEK_API_KEY`.

| Keys | Action |
| --- | --- |
| `Space a a` | Ask OpenCode with `@this` context |
| `Space a s` | Select an OpenCode action |
| `Space a t` | Send a motion or selection to OpenCode (operator) |
| `Space a o` | Toggle the OpenCode terminal |

The first OpenCode action starts a server in a right-hand `snacks.terminal`
split.

### DeepSeek completion (personal)

`lua/plugins/minuet.lua` configures Minuet with DeepSeek's FIM endpoint and adds
it as a Blink source. `DEEPSEEK_API_KEY` must be present, or Minuet is skipped
with a warning. Suggestions appear in the Blink menu with ghost text; `Tab`
accepts, matching the Copilot workflow.

Minuet sends nearby buffer text to DeepSeek. Requests are throttled
(`throttle = 1000`, `debounce = 400`) and limited to one completion
(`n_completions = 1`) to control cost and latency. Toggle Blink integration with
`:Minuet blink toggle`, or inspect the active model with `:Minuet change_model`.

### Copilot

`vim.g.ai_cmp` is derived from the active profile: it is `true` only for `work`
and `both`. It routes Copilot suggestions into Blink's completion menu.
Authentication is local to each installation: use `:Copilot auth`.

Copilot attachment is disabled by default. `lua/plugins/copilot.lua` enables it
only when the global Git setting `copilot.enabled` resolves to boolean `true`:

```sh
git config --global copilot.enabled true   # Enable
git config --global copilot.enabled false  # Disable
git config --global --type=bool --get copilot.enabled  # Inspect
```

Missing or invalid values disable attachment. This is a global opt-in for the
current user's Git configuration, not a per-project setting: repository-local
values are ignored, and eligible files outside Git repositories can also attach.
Set it independently on each machine.

The setting is read once and cached at startup, so restart Neovim after changing
it; the check does not detach buffers that are already attached. Ordinary LSP
completion remains available when Copilot is disabled.

To remove the integration entirely, disable `ai.copilot` in `:LazyExtras` and
restart. To exclude filetypes instead, add:

```lua
return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      filetypes = {
        markdown = false,
        text = false,
      },
    },
  },
}
```

The attachment check and filetype exclusions are not a security boundary or a
replacement for reviewing what data plugins send to external services.

## Tests and debugging

The Python, Rust, and Elixir extras register Neotest adapters. This configuration
adds `lua/plugins/neotest.lua` for C/C++ (`neotest-ctest`) and Lua
(`neotest-plenary`).

C/C++ tests use CTest discovery, so they must be registered with
`gtest_discover_tests()`, `catch_discover_tests()`, or an equivalent CMake
integration. The adapter expects a `CTestTestfile.cmake` at or near the project
root; build the project first, for example:

```sh
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build build
```

By default, `neotest-ctest` recognizes files ending in `_test.cpp`, `_test.cc`,
or `_test.cxx`. Override `is_test_file` in `lua/plugins/neotest.lua` if your
project uses another naming scheme.

Lua tests use `neotest-plenary` for Plenary/busted suites; standalone Lua
projects may need a different adapter. Mason installs `debugpy` for Python
debugging. Rust and C/C++ use CodeLLDB; the CTest adapter is configured to debug
individual tests with CodeLLDB through the usual `<leader>td` mapping. ElixirLS
support does not by itself configure an Elixir debug launch; add an appropriate
adapter/launch configuration before using DAP for Elixir.

For project-specific launches, use `.vscode/launch.json` with an adapter type
configured in nvim-dap. Prefer environment variables over embedded credentials.
The [nvim-dap documentation](https://github.com/mfussenegger/nvim-dap) describes
adapter setup and launch configuration; not every VS Code extension's adapter is
automatically available in Neovim.

For Lua debugging inside a Neovim process, LazyVim's `dap.nlua` extra is enabled.
Testing standalone Lua versus Neovim plugins may need different runners.

## Machine-specific settings

Keep shared defaults portable: avoid absolute home-directory paths or hardcoded
interpreter locations. Prefer runtime managers, PATH discovery, project-local
environments, and environment variables for machine-specific values.

This configuration does not automatically source a local override file. If you
add one, explicitly load it and ignore it before storing private values; never
commit tokens or credentials. Review Git diffs before publishing.
