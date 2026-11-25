{
  description = "macOS dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # Only for claude-code, the 26.05 release lags far behind
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
      # Each file in nix/hosts is one machine, named after its LocalHostName
      hostFiles = builtins.readDir ./nix/hosts;
      hostNames = map (lib.removeSuffix ".nix") (builtins.attrNames hostFiles);

      mkMac =
        hostName:
        nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs; };
          modules = [
            home-manager.darwinModules.home-manager
            ./nix/darwin
            ./nix/hosts/${hostName}.nix
          ];
        };
    in
    {
      darwinConfigurations = lib.genAttrs hostNames mkMac;
    };
}
