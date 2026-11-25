{
  description = "macOS dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { home-manager, nix-darwin, ... }:
    {
      darwinConfigurations.mac = nix-darwin.lib.darwinSystem {
        modules = [
          home-manager.darwinModules.home-manager
          ./nix/macos.nix
          (
            { pkgs, ... }:
            let
              username = "brian.vanburken";
            in
            {
              nixpkgs.hostPlatform = "aarch64-darwin";
              nix.enable = false;
              system.stateVersion = 7;
              system.primaryUser = username;

              users.users.${username}.home = "/Users/${username}";

              programs.fish = {
                enable = true;
                useBabelfish = true;
                shellInit = ''
                  fish_add_path --global --move /run/current-system/sw/bin
                '';
              };
              environment.shells = [ pkgs.fish ];
              environment.variables = {
                EDITOR = "nvim";
                MISE_FISH_AUTO_ACTIVATE = "0";
              };
              security.pam.services.sudo_local.touchIdAuth = true;

              environment.systemPackages = with pkgs; [
                colima
                delta
                docker-client
                exercism
                eza
                fd
                ffmpeg
                gh
                git
                gitleaks
                hyperfine
                jq
                mise
                neovim
                ripgrep
                tree-sitter
                wget
                xq-xml
                yq-go
                yt-dlp
                zoxide
              ];

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "pre-nix";
                users.${username} = import ./nix/home.nix;
              };
            }
          )
        ];
      };
    };
}
