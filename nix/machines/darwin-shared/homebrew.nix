{
  config,
  inputs,
  lib,
  user,
  ...
}:

{
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

  nix-homebrew = {
    enable = true;
    user = user.name;
    # Replaces a Homebrew installed by its own script, keeping the installed packages
    autoMigrate = true;
    mutableTaps = false;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
    # fish-variables.fish already sets the Homebrew paths, `brew shellenv` would slow startup
    enableFishIntegration = false;
  };

  homebrew = {
    enable = true;
    # Upgrades to the versions pinned in flake.lock
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
    # Listed so cleanup doesn't untap them
    taps = builtins.attrNames config.nix-homebrew.taps;
    brews = [
      "mole"
    ];
    casks = [
      "firefox"
      "flux-app"
      "ghostty"
      "iina"
      "keka"
      "libreoffice"
      "obsidian"
      "spotify"
      "steermouse"
      "terminal-browser"
      "tinycast"
    ];
  };

  # Bundle cleanup already removes unused dependencies, so no `brew autoremove`
  system.activationScripts.homebrew.text = lib.mkAfter ''
    echo >&2 "Homebrew cleanup..."
    sudo --user=${lib.escapeShellArg config.homebrew.user} --set-home \
      ${config.homebrew.prefix}/bin/brew cleanup --scrub
  '';
}
