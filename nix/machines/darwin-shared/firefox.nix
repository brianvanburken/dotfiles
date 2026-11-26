{ config, lib, ... }:

let
  policies = import ./firefox-policies.nix {
    inherit lib;
    homeDirectory = config.users.users.${config.system.primaryUser}.home;
    inherit (config.firefox) extraExtensionInstallUrls;
  };
in
{
  options.firefox.extraExtensionInstallUrls = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = { };
    description = "Extensions force-installed on this Mac only, by extension ID.";
  };

  # Enterprise policies for the Homebrew Firefox; check them in about:policies.
  # Activation runs as root, so a bare domain would land in /var/root instead.
  config.system.defaults.CustomSystemPreferences."/Library/Preferences/org.mozilla.firefox" =
    policies
    // {
      EnterprisePoliciesEnabled = true;
    };
}
