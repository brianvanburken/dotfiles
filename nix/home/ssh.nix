{
  config,
  lib,
  pkgs,
  ...
}:

{
  # The key itself is generated per machine by setup/install-macos.sh.
  # No package: UseKeychain only works with macOS's own ssh.
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = lib.optionals pkgs.stdenv.isDarwin [ "${config.xdg.configHome}/colima/ssh_config" ];
    settings."*" = {
      AddKeysToAgent = "yes";
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin { UseKeychain = "yes"; };
  };
}
