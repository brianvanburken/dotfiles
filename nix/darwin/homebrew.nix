{
  homebrew = {
    enable = true;
    onActivation.cleanup = "none";
    taps = [ "s-sigdel/tap" ];
    brews = [
      "mole"
      "s-sigdel/tap/vimhjkl"
    ];
    casks = [
      "calibre"
      "claude"
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
      "steermouse"
      "terminal-browser"
      "whatsapp"
    ];
  };
}
