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

  # From unstable so grammars stay close to upstream; queries ship with them
  treesitterGrammars = pkgs.symlinkJoin {
    name = "treesitter-grammars";
    paths =
      (unstable.vimPlugins.nvim-treesitter.withPlugins (
        grammars: with grammars; [
          bash
          css
          csv
          diff
          dtd
          elixir
          elm
          fish
          git_config
          git_rebase
          gitcommit
          gitignore
          graphql
          haskell
          html
          htmldjango
          ini
          javascript
          json
          nix
          python
          ruby
          rust
          scss
          toml
          tsv
          typescript
          xml
          yaml
        ]
      )).dependencies;
  };

  plugins = with pkgs.vimPlugins; {
    "fff" = fff-nvim;
    "flash.nvim" = flash-nvim;
    "lsp-progress.nvim" = lsp-progress-nvim;
    "nvim-surround" = nvim-surround;
    "nvim-treesitter" = unstable.vimPlugins.nvim-treesitter;
    "vim-startuptime" = vim-startuptime;
  };
in
{
  home.packages = [ neovim ];

  xdg.dataFile = lib.mapAttrs' (
    name: plugin: lib.nameValuePair "nvim/site/pack/nix/opt/${name}" { source = plugin; }
  ) plugins
  // {
    # In start/ so parsers and queries are on the runtimepath without packadd
    "nvim/site/pack/nix/start/treesitter-grammars".source = treesitterGrammars;
  };
}
