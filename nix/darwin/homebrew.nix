{
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    taps = [ "s-sigdel/tap" ];
    brews = [
      "mole"
      "s-sigdel/tap/vimhjkl"
    ];
    casks = [
      "calibre"
      "claude"
      "cleanmymac"
      "cold-turkey-blocker"
      "firefox"
      "flux-app"
      "garmin-express"
      "ghostty"
      "iina"
      "keka"
      "libreoffice"
      "obsidian"
      "proton-mail"
      "proton-pass"
      "protonvpn"
      "signal"
      "spotify"
      "steermouse"
      "terminal-browser"
      "tinycast"
      "whatsapp"
    ];
  };
}
