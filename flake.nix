{
  description = "macOS dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { nix-darwin, ... }:
    {
      darwinConfigurations.mac = nix-darwin.lib.darwinSystem {
        modules = [
          (
            { pkgs, ... }:
            {
              nixpkgs.hostPlatform = "aarch64-darwin";
              nix.enable = false;
              system.stateVersion = 7;

              environment.systemPackages = with pkgs; [
                eza
                fd
                git
                jq
                neovim
                ripgrep
              ];
            }
          )
        ];
      };
    };
}
