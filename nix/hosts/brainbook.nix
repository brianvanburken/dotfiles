{
  config,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = [ pkgs.exercism ];

  # The home-manager wrapper around claude-code inherits its unfree license
  nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "claude-code";
  home-manager.users.${config.system.primaryUser}.imports = [ ../home/claude.nix ];
  # Home Manager does not manage fish, so its session variables never load
  environment.variables.CLAUDE_CONFIG_DIR =
    config.home-manager.users.${config.system.primaryUser}.programs.claude-code.configDir;

  homebrew = {
    taps = [ "s-sigdel/tap" ];
    brews = [ "s-sigdel/tap/vimhjkl" ];
    casks = [
      "calibre"
      "claude"
      "cleanmymac"
      "garmin-express"
      "proton-mail"
      "proton-pass"
      "protonvpn"
      "signal"
      "whatsapp"
    ];
  };
}
