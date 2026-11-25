{ config, lib, ... }:

let
  dotfiles = ../../config;
  dotfilesCheckout = "${config.home.homeDirectory}/Developer/personal/dotfiles/config";
  directories = lib.filterAttrs (_: type: type == "directory") (builtins.readDir dotfiles);
  # These apps write to their own config, so they link to the checkout instead of the read-only store
  appWrittenDirectories = [ "tinycast" ];

  linkFromStore = name: {
    source = dotfiles + "/${name}";
    recursive = true;
  };
  linkFromCheckout = name: {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesCheckout}/${name}";
  };
in
{
  imports = [
    ./direnv.nix
    ./fish.nix
    ./neovim.nix
    ./ssh.nix
    ./terminal-browser.nix
  ];

  home.stateVersion = "26.05";

  xdg.enable = true;
  xdg.configFile = lib.mapAttrs (
    name: _: if lib.elem name appWrittenDirectories then linkFromCheckout name else linkFromStore name
  ) directories;
}
