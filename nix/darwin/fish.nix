{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    useBabelfish = true;
    shellInit = ''
      fish_add_path --global --move /run/current-system/sw/bin
    '';
  };
  environment.shells = [ pkgs.fish ];
  environment.variables.MISE_FISH_AUTO_ACTIVATE = "0";
}
