{ lib, pkgs, ... }:

{
  # Included from config/git/config
  xdg.configFile."git/macos" = lib.mkIf pkgs.stdenv.isDarwin {
    text = ''
      [credential]
      	helper = osxkeychain
    '';
  };
}
