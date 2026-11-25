{ config, lib, ... }:

let
  policies = import ../../common/firefox-policies.nix {
    inherit lib;
    homeDirectory = config.users.users.${config.system.primaryUser}.home;
  };
in
{
  # Enterprise policies for the Homebrew Firefox; check them in about:policies.
  # Activation runs as root, so a bare domain would land in /var/root instead.
  system.defaults.CustomSystemPreferences."/Library/Preferences/org.mozilla.firefox" = policies // {
    EnterprisePoliciesEnabled = true;
  };
}
