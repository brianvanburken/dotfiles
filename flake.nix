{
  description = "macOS dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # For packages where the 26.05 release lags far behind
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    mattpocock-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      user.name = "brianvanburken";

      # Each .nix file in nix/machines is one Mac, named after its LocalHostName
      machineFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) (
        builtins.readDir ./nix/machines
      );
      macNames = map (lib.removeSuffix ".nix") (builtins.attrNames machineFiles);

      mkMac =
        hostName:
        nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs user; };
          modules = [
            home-manager.darwinModules.home-manager
            ./nix/machines/${hostName}.nix
          ];
        };

      darwinConfigurations = lib.genAttrs macNames mkMac;

      # `nix flake check` builds every Mac
      checks.aarch64-darwin = lib.mapAttrs (_: machine: machine.system) darwinConfigurations;
    in
    {
      inherit darwinConfigurations checks;
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-tree;
    };
}
