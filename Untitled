# Contributing and releasing

## Scope

This is a small, opinionated LazyVim configuration. Prefer upstream extras and
small local overrides over copied plugin defaults. Describe behavior changes,
runtime requirements, and new keymaps in the README.

Use a fork for personal preferences. For shared fixes, open a pull request with
the problem, the minimal change, and the checks you ran. Preserve existing
license and attribution notices.

## Local checks

Use StyLua 2.6.0 (the version used by CI). It can be installed with Cargo:

```sh
cargo install stylua --version 2.6.0 --locked
stylua --check .
python3 -m json.tool lazyvim.json > /dev/null
python3 -m json.tool lazy-lock.json > /dev/null
python3 -m json.tool .neoconf.json > /dev/null
git diff --check
```

Run `stylua .` to apply formatting. The formatting check also parses Lua; it
does not validate plugin APIs, install external tools, or exercise language
servers. CI runs formatting and JSON checks without bootstrapping Neovim.

For behavior changes, launch the configuration with a separate `NVIM_APPNAME`
as described in the README. Verify startup, `:checkhealth`, and affected
completion, formatting, test, or debugging workflows in a real project.
Document unsupported or untested platforms rather than claiming compatibility.

## Lockfile policy

Commit `lazy-lock.json` whenever intentionally changing plugin versions.
Do not mix unrelated plugin upgrades into a configuration fix. Restore with
`:Lazy restore`; update deliberately with `:Lazy update`. Record any runtime
or tool-version constraints introduced by an upgrade.

## Public-release checklist

- [ ] Review all tracked and untracked files with `git status` and `git diff`.
- [ ] Inspect staged changes with `git diff --cached` before committing.
- [ ] Review the entire Git history for secrets or private information, not just
      the current checkout. Ignore rules do not remove previously committed data.
      Rotate exposed credentials before publication.
- [ ] Confirm the README's clone URL matches the repository being published.
- [ ] Include the theme, Mason override, enabled extras, lockfile, docs, and license.
- [ ] Pass local checks and the GitHub Actions workflow.
- [ ] Test installation into a fresh application directory and verify the
      language workflows you intend to support.
- [ ] Preserve upstream license/attribution and review licenses for any bundled
      additions. Plugins are downloaded separately.
- [ ] Review repository visibility and GitHub settings before making it public.
- [ ] Create a version tag and release notes only after validation; state known
      limitations and required runtime versions.

Publishing visibility changes and releases are manual maintainer actions.
Do not upload Neovim data/state/cache directories or Copilot credentials.
