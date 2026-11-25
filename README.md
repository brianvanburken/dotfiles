# Dotfiles

To install on macOS:

`zsh -c "$(curl -fsSL https://raw.githubusercontent.com/brianvanburken/dotfiles/main/setup/install-macos.sh)"`

## Nix migration plan (Apple Silicon)

1. Build and test Git, Neovim, ripgrep, fd, eza, and jq from the pinned
   nix-darwin configuration. `setup/Brewfile` keeps only the formulae that
   are not migrated yet. Inventory other formulae with `brew leaves --installed-on-request`
   before migrating them, and back up data for stateful services.
2. Adopt the existing `config/` files with Home Manager. Back up existing
   configs, then migrate Fish, remove Ghostty's hardcoded Homebrew Fish path,
   and verify the lazy direnv and mise loaders in a fresh terminal.
3. Move macOS preferences to nix-darwin. Keep unported GUI apps in Homebrew
   casks or install them through their vendors before removing Homebrew.

### Build the macOS generation

With Determinate Nix installed, build from the repository root:

```sh
nix build --no-link --print-out-paths .#darwinConfigurations.mac.config.system.build.toplevel
```

Test the binaries in `sw/bin` under the printed store path. Building does not
activate the generation, change the login shell, or remove any Brew packages.
Determinate Nix remains responsible for the Nix daemon and configuration.

### Adopt existing configs and switch Fish

The `mac` configuration targets the account in `flake.nix`. Before the first
switch, back up `~/.config`. Home Manager saves conflicting files and links
with a `.pre-nix` suffix, so move the top-level links into this checkout (such
as `~/.config/fish`) out of the way first. Remove only the links, not their
targets, so Home Manager doesn't write into the checkout through them.
Copy `conf.d/config.local.fish` from the old Fish directory into the new one.
Universal variables are generated from `nix/fish-variables.fish` into a
read-only `fish_variables`, so `set -U` fails; change that file and switch
instead. Keep machine-local or secret variables in `config.local.fish`.

Most configs are linked file by file from the store. Edit them in this
repository and switch to apply. Configs that their apps write to (`claude`,
`terminal-browser`, `tinycast`) link to this checkout instead. Neovim plugins
come from nixpkgs and load with `packadd`, so update them with
`nix flake update` and a switch. direnv and nix-direnv come from Home Manager.

nix-darwin refuses to overwrite `/etc/shells` and `/etc/pam.d/sudo_local`
(Touch ID for sudo, now managed by nix-darwin). Move them aside first:

```sh
sudo mv /etc/shells /etc/shells.before-nix-darwin
sudo mv /etc/pam.d/sudo_local /etc/pam.d/sudo_local.before-nix-darwin
```

Then activate with `sudo darwin-rebuild switch --flake .#mac` (use
`sw/bin/darwin-rebuild` from the printed store path on the first switch).

The switch drops Homebrew's Fish from `/etc/shells`, so select the new shell
right away with `chsh -s /run/current-system/sw/bin/fish`. In a fresh
terminal, check that Fish comes from `/run/current-system/sw/bin`, that
`sudo -v` accepts Touch ID, then enter a direnv project and a mise project to
verify lazy activation. Afterwards remove the old copies:
`nix profile remove direnv nix-direnv` and
`rm -rf ~/.local/share/nvim/site/pack/core` (plugins installed by `vim.pack`).
Keep Homebrew installed until the Nix tools and terminal setup are verified.

### macOS preferences and GUI apps

`nix/macos.nix` manages the macOS user preferences and the Homebrew casks.
A switch requires Homebrew and can install missing casks. It does not upgrade
or remove existing Homebrew packages. `setup/install-macos.sh` installs
Homebrew, the remaining formulae and Nix, then runs the first switch.

To remove Homebrew later, migrate the remaining formulae and replace the casks
with vendor or App Store installs, then disable `homebrew.enable` and verify a
switch before uninstalling Homebrew.
