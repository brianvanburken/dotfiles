# Dotfiles

To install on a freshly wiped Mac (Apple Silicon):

`zsh -c "$(curl -fsSL https://raw.githubusercontent.com/brianvanburken/dotfiles/main/setup/install-macos.sh)"`

The script installs the command line tools, Homebrew and Determinate Nix,
clones this repository, and runs the first `darwin-rebuild switch`. It then
makes Nix's Fish the login shell. It is safe to run again.

## Layout

- `flake.nix`: inputs, and one nix-darwin configuration per `.nix` file in
  `nix/machines/`. The account name is set here.
- `nix/machines/<host>.nix`: per-Mac settings, one file per Mac named after its
  hostname (`scutil --get LocalHostName`). Each imports `darwin-shared`.
- `nix/common/`: system modules that are not tied to macOS: Home Manager
  wiring, CLI packages, Fish, and the nixpkgs settings: allowed unfree packages
  and `pkgs.unstable`. `firefox-policies.nix` holds the Firefox policies as
  plain data.
- `nix/machines/darwin-shared/`: shared by every Mac: preferences and Touch ID, Homebrew, the SSH
  agent, colima, and Firefox policies in macOS preferences.
- `nix/home/`: Home Manager, one module per program, shared by every machine.
  `default.nix` links `config/` into `~/.config`; the rest cover direnv, Fish
  universal variables, git, Neovim plugins, SSH and terminal-browser.
  macOS-only settings sit behind `pkgs.stdenv.isDarwin`.

Apply changes with `sudo darwin-rebuild switch --flake .` from the
repository root; it picks the configuration matching the hostname.
`nix flake check` builds every Mac. Update the pinned inputs with
`nix flake update`, and format the Nix files with `nix fmt`.

## Configs

Most configs are linked file by file from the store, so edit them in this
repository and switch. Configs that their apps write to (`tinycast`) link to
this checkout instead. terminal-browser's `settings.json` is generated from
`nix/home/terminal-browser.nix`, so edit it there.

Claude Code, on brainbook only, comes from `nix/home/claude.nix`, which
`nix/machines/brainbook.nix` imports: the binary from nixpkgs-unstable,
a read-only `settings.json` and `CLAUDE.md`, and the mattpocock skills as a
plugin. Changes made from inside Claude Code are lost on the next switch, so
edit `nix/home/claude.nix` instead. Its runtime state (history, login, memory)
stays in a real `~/.config/claude` directory.

Universal variables come from `nix/home/fish-variables.fish` and land in a
read-only `fish_variables`, so `set -U` fails. Change that file and switch
instead. Keep machine-local variables in `~/.config/fish/conf.d/config.local.fish`,
and keep project secrets in that project's `.envrc`.

Neovim plugins come from nixpkgs and load with `packadd`. Language servers
come from nixpkgs too, on the end of `nvim`'s PATH, so project-local ones win;
add them in `nix/home/neovim.nix`. rust-analyzer comes from rustup.

Firefox stays a Homebrew cask. `nix/machines/darwin-shared/firefox.nix` sets its extensions
and settings as enterprise policies in `/Library/Preferences/org.mozilla.firefox`;
see `about:policies` after restarting Firefox. Extensions configure themselves
in Firefox, uBlock Origin included.

## Homebrew

A switch installs missing formulae and casks, and zaps (uninstalls, with
their app data) any not listed in the config. It does not upgrade them. To drop Homebrew, move the formulae to nixpkgs, replace the
casks with vendor or App Store installs, and disable `homebrew.enable`.
