# Neovim development configuration

A personal [LazyVim](https://www.lazyvim.org/) configuration for Python, Rust,
Elixir, C/C++, and Lua. Includes Gruvbox, language-aware completion, GitHub
Copilot on work machines, OpenCode with DeepSeek completion on personal
machines, Git integration, debugging, and test navigation.

This is a configuration, not a standalone distribution. Most behavior comes from
LazyVim; language runtimes and project dependencies must be installed separately.

## Requirements

| Dependency | Purpose |
| --- | --- |
| Neovim >= 0.11.2, built with LuaJIT | LazyVim baseline; local environment uses Neovim 0.12.6 |
| Git >= 2.19 | Plugin installation and Git integration |
| `curl`, `tar`, `unzip`, and a C compiler | Tool downloads and Treesitter parser builds |
| `ripgrep` and `fd` | File and text searches |
| Node.js >= 22 and npm | npm-based language tools such as Pyright; Copilot's Node.js backend if selected |
| `opencode` CLI (personal profile) | OpenCode agent integration inside Neovim |
| `DEEPSEEK_API_KEY` (personal profile) | DeepSeek inline completion through Blink |
| Language runtimes | Python, Rust, and Erlang/Elixir as required by your projects |
| LazyGit (optional) | Interactive Git UI inside Neovim |
| A Nerd Font (recommended) | Icons; configure it in your terminal, not Neovim |

The current setup has been used on macOS. Linux and Windows have not been
validated here; the shell examples below target macOS/Linux.

For macOS, install the base tools with Homebrew:

```sh
brew install neovim git ripgrep fd node lazygit
xcode-select --install
```

Skip the last command if Xcode Command Line Tools are already installed. Use
your preferred runtime manager for Python, Rust, Erlang, and Elixir. If using
asdf or mise, ensure versions are selected and executable from the shell that
launches Neovim, including outside a project directory.

## Installation

### Try without replacing your existing setup

Use a separate application name, which also isolates plugins, state, and caches:

```sh
config_root="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$config_root"
git clone https://github.com/dariodip/neovim-config.git "$config_root/nvim-dev"
NVIM_APPNAME=nvim-dev nvim
```

Use `NVIM_APPNAME=nvim-dev` for every subsequent command in this mode. If the
destination already exists, inspect it rather than overwriting it.

### Install as your default configuration

Close Neovim first. Back up the current config without deleting it:

```sh
(
  set -eu
  config_root="${XDG_CONFIG_HOME:-$HOME/.config}"
  mkdir -p "$config_root"
  if [ -e "$config_root/nvim" ] || [ -L "$config_root/nvim" ]; then
    backup="$config_root/nvim.backup.$(date +%Y%m%d-%H%M%S)"
    test ! -e "$backup" && test ! -L "$backup"
    mv "$config_root/nvim" "$backup"
  fi
  git clone https://github.com/dariodip/neovim-config.git "$config_root/nvim"
)
nvim
```

An existing installation's plugins/state are not backed up by this command.
Use the isolated installation above if you need to keep those completely separate.

### First launch

1. Allow lazy.nvim to bootstrap and install plugins. Installation requires network
   access and executes third-party plugin/build code.
2. Run `:Lazy restore` to align plugins with the committed `lazy-lock.json`.
3. Open `:Mason` and allow automatic tool installations to finish.
4. Open a source file in a project and run `:checkhealth`. Use `:ConformInfo` to
   inspect formatters and `:checkhealth vim.lsp` to inspect language servers.
5. To use Copilot, run `:Copilot auth` and complete browser authentication with
   an account that has Copilot access. Enable attachment with
   `git config --global copilot.enabled true` in your shell, then restart Neovim.
   Verify with `:Copilot status`.
6. On a personal machine, export `NVIM_PROFILE=personal` and
   `DEEPSEEK_API_KEY` in the shell that launches Neovim. This enables the
   OpenCode agent and DeepSeek completion instead of Copilot; verify with
   `:checkhealth opencode` and `:Minuet change_model`.

Copilot is optional. It may send code/context to GitHub's service when active;
review your organization's policies before opening restricted projects. See
[customization](docs/customization.md#ai-profiles) for profile selection, the
global opt-in setting, and how to disable integrations. Repository-local Git
settings are ignored.

## Language support

| Language | Enabled integration | Project prerequisites / limitations |
| --- | --- | --- |
| Python | Pyright, Ruff, Neotest Python, DAP Python, virtualenv selector | Project interpreter and test dependencies; `debugpy` is installed by Mason |
| Rust | rustaceanvim, rust-analyzer, Cargo tests, CodeLLDB | Rust toolchain, rustfmt, Clippy, and rust-analyzer on PATH |
| Elixir | ElixirLS, ExUnit through Neotest, conditional Credo linting | Compatible Erlang/Elixir; fetch Mix dependencies; Credo needs project configuration |
| C/C++ | clangd with clang-tidy, CodeLLDB, Neotest CTest adapter | Compiler/build system, compilation database, and tests enumerated by CTest (`gtest_discover_tests()`, `catch_discover_tests()`, and similar) |
| Lua | LuaLS, lazydev, StyLua, Neotest Plenary adapter, DAP via `nlua` | Plenary/busted tests for Neovim plugins; standalone Lua may need a different adapter |

Language extras supply defaults, not a guarantee that every tool is available.
Mason installs configured tools, but not project dependencies or language
runtimes. For example:

```sh
rustup component add rust-analyzer rustfmt clippy
```

Run this with the project's selected Rust toolchain. In Python projects, activate
the virtual environment before starting Neovim or use `:VenvSelect`; install
pytest if that is the project's test runner. For CMake projects, generate a
compilation database with `cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`
and make it discoverable by clangd.

Formatting uses LazyVim's format-on-save integration, Conform, and LSP fallback.
No repository-wide Python formatter preference overrides the enabled extras.
C/C++ tests use the CTest adapter and Lua tests use the Plenary adapter. Elixir
debug launching still needs a project-specific adapter and launch configuration;
see [customization](docs/customization.md).

## Everyday commands

`<leader>` is Space. These are LazyVim defaults and may change with plugin updates.
Press `Space` and pause for the which-key menu.

| Keys / command | Action |
| --- | --- |
| `Space f f` / `Space s g` | Find files / search text |
| `g d` / `K` | Go to definition / hover documentation |
| `Space c a` / `Space c r` | Code actions / rename symbol |
| `Space c f` | Format current buffer |
| `Space g g` | LazyGit (requires the `lazygit` executable and a Git repository) |
| `Space g s` / `Space g l` | Git status / history |
| `]h` / `[h` | Next / previous changed hunk |
| `Space g h s` / `Space g h p` | Stage / preview hunk |
| `Space t r` / `Space t t` | Run nearest test / current test file |
| `Space t s` / `Space t o` | Test summary / output |
| `Space d b` / `Space d c` | Toggle breakpoint / run or continue debugging |
| `Space d u` | Toggle debugger UI |
| `:Lazy` / `:LazyExtras` | Manage plugins / language and feature extras |
| `:Mason` / `:ConformInfo` | Manage external tools / inspect formatting |

The active AI profile is selected at startup by `NVIM_PROFILE`; see
[customization](docs/customization.md#ai-profiles). In `work` mode Copilot
suggestions appear in the Blink completion menu; in `personal` mode DeepSeek
suggestions do. Use `Ctrl-n` / `Ctrl-p` to select an item and `Ctrl-y` or `Tab`
to accept it; `Enter` keeps its normal behavior.

Personal mode also provides these OpenCode mappings:

| Keys | Action |
| --- | --- |
| `Space a a` | Ask OpenCode with `@this` context |
| `Space a s` | Select an OpenCode action |
| `Space a t` | Send a motion or selection to OpenCode |
| `Space a o` | Toggle the OpenCode terminal |

## Layout

```text
init.lua                    Entry point
lua/config/ai.lua           NVIM_PROFILE selection for Copilot, OpenCode, DeepSeek
lua/config/lazy.lua         Plugin manager bootstrap and LazyVim imports
lua/config/options.lua      Editor options, clipboard, and Blink AI routing
lua/config/keymaps.lua      Custom keymaps
lua/config/autocmds.lua     Custom autocmds
lua/plugins/blink.lua       Blink keymaps, ghost text, and DeepSeek source
lua/plugins/colorscheme.lua Gruvbox theme
lua/plugins/copilot.lua     Profile and global Git opt-in for Copilot attachment
lua/plugins/minuet.lua      DeepSeek FIM completion for the personal profile
lua/plugins/opencode.lua    OpenCode agent and terminal for the personal profile
lua/plugins/mason.lua       Mason package deduplication and debugpy
lua/plugins/neotest.lua     CTest and Plenary Neotest adapters
lua/plugins/example.lua     Inactive upstream plugin examples
lazyvim.json                Enabled LazyVim extras and metadata
lazy-lock.json              Plugin commit lockfile
.neoconf.json               Optional Neoconf settings (not enabled as an extra here)
stylua.toml                 Lua formatting rules
```

## Updating and using multiple machines

Commit configuration changes and `lazy-lock.json` together. On another machine,
clone this repository, install prerequisites, run `:Lazy restore`, and set
`NVIM_PROFILE` appropriately. Authenticate Copilot independently on work
machines, or export `DEEPSEEK_API_KEY` on personal machines. Never copy
authentication tokens between installations.

For an existing checkout, inspect `git status` before pulling, then run:

```sh
git pull --ff-only
```

Use `:Lazy restore` after pulling. To intentionally update plugin versions, run
`:Lazy update`, test the languages you use, then review and commit the lockfile
diff. `:Lazy sync` also updates plugins; it is not a pinned restore operation.

The lockfile does **not** pin Mason tool versions, runtimes, system packages, or
Treesitter downloads. Keep project dependencies and runtime versions in the
project's own files, such as `pyproject.toml`, `rust-toolchain.toml`, or
`.tool-versions`.

Do not version Neovim's data, state, caches, or credentials. Inspect their actual
locations with `:lua print(vim.fn.stdpath("data"))` (or `"state"` / `"cache"`).

## Troubleshooting

| Symptom | Check |
| --- | --- |
| Mason says a package is already installing | The local Mason spec deduplicates requests shared by Rust and C/C++; let an active install finish, then restart. Inspect `:MasonLog` if it persists. |
| npm tools fail with an asdf/mise version error | Run `node --version` and `npm --version` in the launching shell; select a runtime outside project directories too. |
| Python imports or tests use the wrong interpreter | Activate the project environment before launching or use `:VenvSelect`; verify dependencies there. |
| C/C++ headers or includes are unresolved | Check clangd's compilation database and project compiler flags. |
| No Copilot completions | Check `git config --global --type=bool --get copilot.enabled`, restart after enabling, then check `:Copilot status`, authentication, network access, and Blink's enabled sources. Also confirm `NVIM_PROFILE` is `work` or `both`. |
| No DeepSeek completions | Confirm `NVIM_PROFILE=personal` or `both`, `DEEPSEEK_API_KEY` is set in the launching shell, `:Minuet change_model` responds, and Minuet is enabled in Blink (`:Minuet blink toggle`). |
| OpenCode mappings are missing | Confirm `NVIM_PROFILE=personal` or `both`, the `opencode` executable is on `PATH`, and `:checkhealth opencode` passes. Restart Neovim after changing the profile. |
| Formatting is missing or unexpected | Check `:ConformInfo`, attached LSPs, and project formatter configuration. |
| Debugging or tests do not start | Check the language adapter, executable/runtime, build output, and project dependencies; DAP core alone is not an adapter. |

Use the isolated install when reporting an issue so an old plugin directory does
not obscure the cause. Report Neovim/OS versions and relevant health output;
redact credentials, proprietary code, and personal paths.

## Development and release

See [CONTRIBUTING.md](CONTRIBUTING.md) for validation and the public-release
checklist, and [customization](docs/customization.md) for extending the setup.

## License and acknowledgments

Distributed under the [Apache License 2.0](LICENSE). Based on the
[LazyVim starter](https://github.com/LazyVim/starter), powered by
[LazyVim](https://github.com/LazyVim/LazyVim) and
[lazy.nvim](https://github.com/folke/lazy.nvim). Plugins and downloaded tools
retain their own licenses. This project is not an official LazyVim or GitHub
product.
