{ user, ... }:

{
  imports = [
    ../../common
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
  # System-wide, so the daemon accepts it and activation can't recreate ~/.nix-profile and ~/.nix-defexpr
  environment.etc."nix/nix.custom.conf" = {
    text = ''
      use-xdg-base-directories = true
    '';
    # The installer's placeholder, which only holds comments
    knownSha256Hashes = [ "3bd68ef979a42070a44f8d82c205cfd8e8cca425d91253ec2c10a88179bb34aa" ];
  };
  system.primaryUser = user.name;

  networking.applicationFirewall.enable = true;

  users.users.${user.name}.home = "/Users/${user.name}";
}
