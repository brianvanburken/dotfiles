{ user, ... }:

{
  imports = [
    ../common
    ./firefox.nix
    ./fish.nix
    ./homebrew.nix
    ./macos.nix
    ./packages.nix
    ./ssh.nix
  ];

  # setup/install-macos.sh only supports Apple Silicon
  nixpkgs.hostPlatform = "aarch64-darwin";
  # Determinate Nix manages Nix itself
  nix.enable = false;
  system.primaryUser = user.name;

  users.users.${user.name}.home = "/Users/${user.name}";
}
