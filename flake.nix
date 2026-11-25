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
      home-manager,
      nix-darwin,
      nixpkgs-unstable,
      mattpocock-skills,
      ...
    }:
    let
      allowClaudeCode = pkg: nixpkgs-unstable.lib.getName pkg == "claude-code";
    in
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
              # The home-manager wrapper around claude-code inherits its unfree license
              nixpkgs.config.allowUnfreePredicate = allowClaudeCode;
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
                extraSpecialArgs = {
                  inherit mattpocock-skills;
                  inherit
                    (import nixpkgs-unstable {
                      system = "aarch64-darwin";
                      config.allowUnfreePredicate = allowClaudeCode;
                    })
                    claude-code
                    ;
                };
                users.${username} = import ./nix/home.nix;
              };
            }
          )
        ];
      };
    };
}
