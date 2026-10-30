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

## Copilot

`vim.g.ai_cmp = true` routes Copilot suggestions into Blink's completion menu.
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

Restart Neovim after changing the setting; the attachment check does not detach
buffers that are already attached. Ordinary LSP completion remains available
when Copilot is disabled.

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

Python, Rust, and Elixir extras register Neotest adapters. C/C++ and Lua require
adapters matching the actual framework in use; avoid installing one globally
without choosing the project's test runner.

Python debugging requires Mason's `debugpy` package (`:MasonInstall debugpy`).
Rust and C/C++ use CodeLLDB. ElixirLS support does not by itself configure an
Elixir debug launch; add an appropriate adapter/launch configuration before
using DAP for Elixir.

For project-specific launches, use `.vscode/launch.json` with an adapter type
configured in nvim-dap. Prefer environment variables over embedded credentials.
The [nvim-dap documentation](https://github.com/mfussenegger/nvim-dap) describes
adapter setup and launch configuration; not every VS Code extension's adapter is
automatically available in Neovim.

For Lua debugging inside a Neovim process, evaluate LazyVim's `dap.nlua` extra.
Testing standalone Lua versus Neovim plugins may need different runners.

## Machine-specific settings

Keep shared defaults portable: avoid absolute home-directory paths or hardcoded
interpreter locations. Prefer runtime managers, PATH discovery, project-local
environments, and environment variables for machine-specific values.

This configuration does not automatically source a local override file. If you
add one, explicitly load it and ignore it before storing private values; never
commit tokens or credentials. Review Git diffs before publishing.
