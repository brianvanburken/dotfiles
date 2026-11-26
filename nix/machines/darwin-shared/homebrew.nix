{
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";
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
}
