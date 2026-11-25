{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    useBabelfish = true;
  };
  environment.shells = [ pkgs.fish ];
  environment.variables.MISE_FISH_AUTO_ACTIVATE = "0";
}
