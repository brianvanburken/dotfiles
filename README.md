# Dotfiles

To install on macOS:

`zsh -c "$(curl -fsSL https://raw.githubusercontent.com/brianvanburken/dotfiles/main/setup/install-macos.sh)"`

## Nix migration plan (Apple Silicon)

1. Build and test Git, Neovim, ripgrep, fd, eza, and jq from the pinned
   nix-darwin configuration. Keep the Brewfile as a fallback until after
   cutover. Inventory other formulae with `brew leaves --installed-on-request`
   before migrating them, and back up data for stateful services.
2. Adopt the existing `config/` files with Home Manager. Back up existing
   configs, then migrate Fish, remove Ghostty's hardcoded Homebrew Fish path,
   and verify the lazy direnv and mise loaders in a fresh terminal.
3. Move macOS preferences to nix-darwin. Keep unported GUI apps in Homebrew
   casks or install them through their vendors before removing Homebrew.

### Build the first CLI generation

With Determinate Nix installed, build from the repository root:

```sh
nix build --no-link --print-out-paths .#darwinConfigurations.mac.config.system.build.toplevel
```

Test the binaries in `sw/bin` under the printed store path. Building does not
activate the generation, change the login shell, or remove any Brew packages.
Determinate Nix remains responsible for the Nix daemon and configuration.

### Adopt existing configs and switch Fish

The `mac` configuration targets the account in `flake.nix`. Before the first
switch, back up `~/.config`. Move any top-level links into this checkout (such
as `~/.config/fish`) out of the way without moving or deleting their targets.
Copy any local files you want to keep, such as `fish_variables` and
`conf.d/config.local.fish`, from the old Fish directory into the new one.
Keep credentials and other untracked state out of the flake.

Home Manager links tracked files individually and saves conflicting files with
a `.pre-nix` suffix. Edit managed files in this repository, not through the
links. Neovim's plugin lockfile is copied on first activation so Neovim can
update it in place; copy it back to the repository to commit a plugin update.
After building successfully and preparing the backups, activate with
`sudo darwin-rebuild switch --flake .#mac` (use `sw/bin/darwin-rebuild`
from the printed store path on the first switch).

nix-darwin registers the new shell without taking ownership of the existing
macOS account. After the switch, select it with
`chsh -s /run/current-system/sw/bin/fish`. In a fresh terminal, check that Fish
comes from `/run/current-system/sw/bin`, then enter a direnv project and a mise
project to verify lazy activation.
Keep Homebrew installed until the Nix tools and terminal setup are verified.
