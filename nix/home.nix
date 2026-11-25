{ config, lib, pkgs, ... }:

let
  dotfiles = ../config;
  dotfilesCheckout = "${config.home.homeDirectory}/Developer/personal/dotfiles/config";
  directories = lib.filterAttrs (_: type: type == "directory") (builtins.readDir dotfiles);
  appWrittenDirectories = [ "terminal-browser" "tinycast" ];

  linkFromStore = name: {
    source = dotfiles + "/${name}";
    recursive = true;
  };
  linkFromCheckout = name: {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesCheckout}/${name}";
  };

  # Read-only, so `set -U` fails loudly; change nix/fish-variables.fish instead.
  # The interactive run first lets fish record its migration version.
  fishVariables = pkgs.runCommand "fish_variables" { nativeBuildInputs = [ pkgs.fish ]; } ''
    # No exported XDG_* variables, they would shadow the universal ones
    export HOME="$TMPDIR/home"
    fish --interactive --command exit
    fish ${./fish-variables.fish} ${lib.escapeShellArg config.home.homeDirectory}
    cp "$HOME/.config/fish/fish_variables" "$out"
  '';

  neovimPlugins = with pkgs.vimPlugins; {
    "fff" = fff-nvim;
    "flash.nvim" = flash-nvim;
    "lsp-progress.nvim" = lsp-progress-nvim;
    "mason.nvim" = mason-nvim;
    "nvim-surround" = nvim-surround;
    "nvim-treesitter" = nvim-treesitter;
    "vim-startuptime" = vim-startuptime;
  };
in
{
  imports = [ ./claude.nix ];

  home.stateVersion = "26.05";

  xdg.enable = true;
  xdg.configFile = lib.mapAttrs (
    name: _: if lib.elem name appWrittenDirectories then linkFromCheckout name else linkFromStore name
  ) directories // {
    "fish/fish_variables".source = fishVariables;
  };

  xdg.dataFile = lib.mapAttrs' (
    name: plugin: lib.nameValuePair "nvim/site/pack/nix/opt/${name}" { source = plugin; }
  ) neovimPlugins;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableFishIntegration = false;
  };
}
