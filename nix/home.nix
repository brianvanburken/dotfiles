{ config, lib, pkgs, ... }:

let
  dotfiles = ../config;
  directories = lib.filterAttrs (_: type: type == "directory") (builtins.readDir dotfiles);
  neovimLock = "nvim-pack-lock.json";
in
{
  home.stateVersion = "26.05";

  xdg.enable = true;
  xdg.configFile = lib.mapAttrs (name: _: {
    source =
      if name == "nvim" then
        lib.cleanSourceWith {
          src = dotfiles + "/nvim";
          filter = path: _: baseNameOf path != neovimLock;
        }
      else
        dotfiles + "/${name}";
    recursive = true;
  }) directories // {
    "direnv/lib/nix-direnv-path.sh".text = ''
      NIX_DIRENV_RC="${pkgs.nix-direnv}/share/nix-direnv/direnvrc"
    '';
  };

  home.activation.seedNeovimLock = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    lock=${lib.escapeShellArg "${config.xdg.configHome}/nvim/${neovimLock}"}
    if [[ ! -e "$lock" && ! -L "$lock" ]]; then
      run mkdir -p -- "$(dirname -- "$lock")"
      run install -m 0644 -- ${dotfiles}/nvim/${neovimLock} "$lock"
    fi
  '';
}
