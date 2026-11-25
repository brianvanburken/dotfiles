{ config, ... }:

{
  system.defaults = {
    NSGlobalDomain = {
      AppleFontSmoothing = 1;
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 10;
      KeyRepeat = 1;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticWindowAnimationsEnabled = false;
      NSScrollAnimationEnabled = false;
      NSWindowResizeTime = 0.001;
      "com.apple.springing.delay" = 0.2;
      "com.apple.springing.enabled" = true;
    };

    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.0;
      expose-animation-duration = 0.0;
      orientation = "left";
      static-only = true;
    };

    finder = {
      CreateDesktop = false;
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv";
      _FXSortFoldersFirst = true;
    };

    screencapture.location = "${config.users.users.${config.system.primaryUser}.home}/Downloads";

    WindowManager = {
      EnableTiledWindowMargins = false;
      GloballyEnabled = false;
    };

    CustomUserPreferences = {
      NSGlobalDomain = {
        NSBrowserColumnAnimationSpeedMultiplier = 0.0;
        NSDocumentRevisionsWindowTransformAnimation = false;
        NSScrollViewRubberbanding = false;
        NSToolbarFullScreenAnimationDuration = 0.0;
        QLPanelAnimationDuration = 0.0;
      };
      "com.apple.AIWritingTools".enabled = false;
      "com.apple.Passwords".isFirstLaunch = false;
      "com.apple.TextEdit" = {
        PlainTextEncoding = 4;
        PlainTextEncodingForWrite = 4;
        RichText = 0;
      };
      "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
      "com.apple.dock" = {
        springboard-hide-duration = 0.0;
        springboard-page-duration = 0.0;
        springboard-show-duration = 0.0;
      };
      "com.apple.finder".DisableAllAnimations = true;
      "com.apple.screensaver" = {
        askForPassword = 1;
        askForPasswordDelay = 0;
        idleTime = 300;
      };
    };
  };

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
      "tinycast"
      "whatsapp"
    ];
  };
}
