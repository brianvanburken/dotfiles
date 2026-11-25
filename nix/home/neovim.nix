{ lib, pkgs, ... }:

let
  plugins = with pkgs.vimPlugins; {
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
  xdg.dataFile = lib.mapAttrs' (
    name: plugin: lib.nameValuePair "nvim/site/pack/nix/opt/${name}" { source = plugin; }
  ) plugins;
}
