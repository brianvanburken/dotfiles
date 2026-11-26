{
  config,
  inputs,
  pkgs,
  user,
  ...
}:

{
  imports = [ ./darwin-shared ];

  system.stateVersion = 7;

  networking.computerName = "BrainBook";

  environment.systemPackages = [ pkgs.exercism ];

  home-manager.users.${user.name}.imports = [ ../home/claude.nix ];
  # Home Manager does not manage fish, so its session variables never load
  environment.variables.CLAUDE_CONFIG_DIR =
    config.home-manager.users.${user.name}.programs.claude-code.configDir;

  firefox.extraExtensionInstallUrls = {
    "{d0210f13-a970-4f1e-8322-0f76ec80adde}" =
      "https://addons.mozilla.org/firefox/downloads/latest/instapaper-official/latest.xpi";
    # Bypass Paywalls Clean is not on addons.mozilla.org; it updates itself through its own update_url
    "magnolia@12.34" =
      "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass_paywalls_clean-4.5.0.0.xpi";
  };

  nix-homebrew.taps."s-sigdel/homebrew-tap" = inputs.homebrew-s-sigdel-tap;

  homebrew = {
    # Trusted in the Brewfile: bundle cleanup replaces trust entries with the Brewfile's
    brews = [
      {
        name = "s-sigdel/tap/vimhjkl";
        trusted = true;
      }
    ];
    casks = [
      "backblaze"
      "calibre"
      "claude"
      "cleanmymac"
      "garmin-express"
      "proton-mail"
      "proton-pass"
      "protonvpn"
      "signal"
      "synology-drive"
      "whatsapp"
    ];
  };
}
