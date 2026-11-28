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
    # Pins Homebrew and its taps, so casks and formulae only change with flake.lock
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nix-homebrew.inputs.brew-src.follows = "brew-src";
    # Locked together with homebrew-core, which needs a Homebrew at least as new as itself
    brew-src = {
      url = "github:Homebrew/brew";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-s-sigdel-tap = {
      url = "github:s-sigdel/homebrew-tap";
      flake = false;
    };
    mattpocock-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };
    rust-skills = {
      url = "github:leonardomso/rust-skills";
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
            {
              networking.hostName = hostName;
              system.defaults.smb.NetBIOSName = hostName;
            }
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
