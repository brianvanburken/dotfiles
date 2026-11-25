# Dotfiles

To install on a freshly wiped Mac (Apple Silicon):

`zsh -c "$(curl -fsSL https://raw.githubusercontent.com/brianvanburken/dotfiles/main/setup/install-macos.sh)"`

The script installs the command line tools, Homebrew and Determinate Nix,
clones this repository, and runs the first `darwin-rebuild switch`. It then
makes Nix's Fish the login shell. It is safe to run again.

## Layout

- `flake.nix`: inputs, and one nix-darwin configuration per file in
  `nix/hosts/`.
- `nix/hosts/`: per-machine settings, one file per machine named after its
  hostname (`scutil --get LocalHostName`). Every machine shares the rest.
- `nix/darwin/`: nix-darwin, one module per context. `default.nix` names the
  account and wires up Home Manager; the rest cover CLI packages, Fish,
  macOS preferences and Touch ID, Homebrew, and the SSH agent.
- `nix/home/`: Home Manager, one module per program. `default.nix` links
  `config/` into `~/.config`; the rest cover direnv, Fish
  universal variables, Neovim plugins, SSH and terminal-browser.

Apply changes with `sudo darwin-rebuild switch --flake .` from the
repository root; it picks the configuration matching the hostname. Update the pinned inputs with `nix flake update`, and format the Nix files with `nix fmt`.

## Configs

Most configs are linked file by file from the store, so edit them in this
repository and switch. Configs that their apps write to (`tinycast`) link to
this checkout instead. terminal-browser's `settings.json` is generated from
`nix/home/terminal-browser.nix`, so edit it there.

Claude Code, on brainbook only, comes from `nix/home/claude.nix`, which
`nix/hosts/brainbook.nix` imports: the binary from nixpkgs-unstable,
a read-only `settings.json` and `CLAUDE.md`, and the mattpocock skills as a
plugin. Changes made from inside Claude Code are lost on the next switch, so
edit `nix/home/claude.nix` instead. Its runtime state (history, login, memory)
stays in a real `~/.config/claude` directory.

Universal variables come from `nix/home/fish-variables.fish` and land in a
read-only `fish_variables`, so `set -U` fails. Change that file and switch
instead. Keep machine-local variables in `~/.config/fish/conf.d/config.local.fish`,
and keep project secrets in that project's `.envrc`.

Neovim plugins come from nixpkgs and load with `packadd`.

## Homebrew

A switch installs missing formulae and casks, and zaps (uninstalls, with
their app data) any not listed in the config. It does not upgrade them. To drop Homebrew, move the formulae to nixpkgs, replace the
casks with vendor or App Store installs, and disable `homebrew.enable`.
