{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    useBabelfish = true;
  };
  environment.shells = [ pkgs.fish ];
}
