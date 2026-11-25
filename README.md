# Dotfiles

To install on a freshly wiped Mac (Apple Silicon):

`zsh -c "$(curl -fsSL https://raw.githubusercontent.com/brianvanburken/dotfiles/main/setup/install-macos.sh)"`

The script installs the command line tools, Homebrew and Determinate Nix,
clones this repository, and runs the first `darwin-rebuild switch`. It then
makes Nix's Fish the login shell. It is safe to run again.

## Layout

- `flake.nix`: the `mac` nix-darwin configuration for the account it names.
  It covers the CLI packages, Fish, environment variables and Touch ID for sudo.
- `nix/macos.nix`: macOS preferences and the Homebrew formulae and casks.
- `nix/home.nix`: Home Manager. Links `config/` into `~/.config`, generates
  Fish universal variables, and installs the Neovim plugins and direnv.

Apply changes with `sudo darwin-rebuild switch --flake .#mac` from the
repository root. Update the pinned inputs with `nix flake update`.

## Configs

Most configs are linked file by file from the store, so edit them in this
repository and switch. Configs that their apps write to (`terminal-browser`,
`tinycast`) link to this checkout instead.

Claude Code comes from `nix/claude.nix`: the binary from nixpkgs-unstable,
a read-only `settings.json` and `CLAUDE.md`, and the mattpocock skills as a
plugin. Changes made from inside Claude Code are lost on the next switch, so
edit `nix/claude.nix` instead. Its runtime state (history, login, memory)
stays in a real `~/.config/claude` directory.

Universal variables come from `nix/fish-variables.fish` and land in a
read-only `fish_variables`, so `set -U` fails. Change that file and switch
instead. Keep machine-local variables in `~/.config/fish/conf.d/config.local.fish`,
and keep project secrets in that project's `.envrc`.

Neovim plugins come from nixpkgs and load with `packadd`.

## Homebrew

A switch installs missing formulae and casks. It does not upgrade or remove
Homebrew packages. To drop Homebrew, move the formulae to nixpkgs, replace the
casks with vendor or App Store installs, and disable `homebrew.enable`.
