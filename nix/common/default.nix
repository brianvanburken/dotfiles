{ inputs, user, ... }:

{
  imports = [
    ./fish.nix
    ./nixpkgs.nix
    ./packages.nix
  ];

  # The platform modules set users.users.<name>.home, which Home Manager reads
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "pre-nix";
    extraSpecialArgs = { inherit inputs user; };
    users.${user.name} = import ../home;
  };
}
