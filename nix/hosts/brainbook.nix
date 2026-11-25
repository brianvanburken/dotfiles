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

  system.defaults.CustomSystemPreferences."/Library/Preferences/org.mozilla.firefox".ExtensionSettings =
    {
      "{d0210f13-a970-4f1e-8322-0f76ec80adde}" = {
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/instapaper-official/latest.xpi";
      };
      # Bypass Paywalls Clean is not on addons.mozilla.org; it updates itself through its own update_url
      "magnolia@12.34" = {
        installation_mode = "force_installed";
        install_url = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass_paywalls_clean-4.5.0.0.xpi";
      };
    };

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
