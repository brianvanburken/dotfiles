{ config, lib, inputs, ... }:

{
  imports = [
    ./fish.nix
    ./homebrew.nix
    ./macos.nix
    ./packages.nix
    ./ssh.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  # The home-manager wrapper around claude-code inherits its unfree license
  nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "claude-code";
  nix.enable = false;
  system.stateVersion = 7;
  system.primaryUser = "brianvanburken";

  users.users.${config.system.primaryUser}.home = "/Users/${config.system.primaryUser}";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "pre-nix";
    extraSpecialArgs = { inherit inputs; };
    users.${config.system.primaryUser} = import ../home;
  };
}
