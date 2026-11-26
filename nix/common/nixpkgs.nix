{ inputs, lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    lib.elem (lib.getName pkg) [
      "claude-code"
      "copilot-language-server"
    ];

  # For packages where the 26.05 release lags far behind, used as pkgs.unstable.<name>
  nixpkgs.overlays = [
    (_final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (prev.stdenv.hostPlatform) system;
        inherit (prev) config;
      };
    })
  ];
}
