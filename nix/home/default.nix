{ lib, ... }:

let
  dotfiles = ../../config;
  directories = lib.filterAttrs (_: type: type == "directory") (builtins.readDir dotfiles);

  linkFromStore = name: {
    source = dotfiles + "/${name}";
    recursive = true;
  };
in
{
  imports = [
    ./claude.nix
    ./direnv.nix
    ./fish.nix
    ./neovim.nix
    ./ssh.nix
    ./terminal-browser.nix
  ];

  home.stateVersion = "26.05";

  xdg.enable = true;
  xdg.configFile = lib.mapAttrs (name: _: linkFromStore name) directories;
}
