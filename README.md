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

Test the binaries in `sw/bin` under the printed store path. This build does not
activate the generation, change the login shell, or remove any Brew packages.
Determinate Nix remains responsible for the Nix daemon and configuration.
