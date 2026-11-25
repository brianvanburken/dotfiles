{
  lib,
  pkgs,
  inputs,
  ...
}:

let
  unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfreePredicate = pkg: lib.getName pkg == "copilot-language-server";
  };

  # rust-analyzer is left out so rustup's, which matches the toolchain, is used
  languageServers = with pkgs; [
    elmPackages.elm-language-server
    fish-lsp
    lua-language-server
    markdown-oxide
    oxfmt
    oxlint
    taplo
    unstable.copilot-language-server
    # 26.05 ships TypeScript 5, which has no `tsc --lsp`
    unstable.typescript
    vscode-langservers-extracted
    yaml-language-server
  ];

  # Suffixed so tools from a project's PATH (node_modules, rustup) win
  neovim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
    extraMakeWrapperArgs = "--suffix PATH : ${lib.makeBinPath languageServers}";
  };

  plugins = with pkgs.vimPlugins; {
    "fff" = fff-nvim;
    "flash.nvim" = flash-nvim;
    "lsp-progress.nvim" = lsp-progress-nvim;
    "nvim-surround" = nvim-surround;
    "nvim-treesitter" = nvim-treesitter;
    "vim-startuptime" = vim-startuptime;
  };
in
{
  home.packages = [ neovim ];

  xdg.dataFile = lib.mapAttrs' (
    name: plugin: lib.nameValuePair "nvim/site/pack/nix/opt/${name}" { source = plugin; }
  ) plugins;
}
