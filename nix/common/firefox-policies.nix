# Firefox enterprise policies as plain data, applied by nix/darwin/firefox.nix
{ lib, homeDirectory }:

let
  fromAddonsMozillaOrg =
    slug: "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
  extensionInstallUrls = {
    "uBlock0@raymondhill.net" = fromAddonsMozillaOrg "ublock-origin";
    "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = fromAddonsMozillaOrg "vimium-ff";
    "78272b6fa58f4a1abaac99321d503a20@proton.me" = fromAddonsMozillaOrg "proton-pass";
    "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}" = fromAddonsMozillaOrg "auto-tab-discard";
    "nl-NL@dictionaries.addons.mozilla.org" = fromAddonsMozillaOrg "woordenboek-nederlands";
  };
  forceInstall = install_url: {
    installation_mode = "force_installed";
    inherit install_url;
    # In the extensions panel, even when the extension asks for the toolbar
    default_area = "menupanel";
  };
  # Applied on every start; changes made in Firefox last until it restarts
  applyOnEveryStart = value: {
    Value = value;
    Status = "user";
  };

  toolbarLayout = {
    placements = {
      nav-bar = [
        "sidebar-button"
        "back-button"
        "forward-button"
        "stop-reload-button"
        "vertical-spacer"
        "urlbar-container"
        "unified-extensions-button"
        "downloads-button"
      ];
      TabsToolbar = [ ];
      vertical-tabs = [ "tabbrowser-tabs" ];
      PersonalToolbar = [ "personal-bookmarks" ];
      widget-overflow-fixed-list = [ ];
      # Firefox adds extension buttons here itself
      unified-extensions-area = [ ];
    };
    # Without it Firefox treats the layout as old and migrates it
    currentVersion = 28;
  };

  preferences = {
    # Look
    "extensions.activeThemeID" = "default-theme@mozilla.org";
    "browser.compactmode.show" = true;
    "browser.uidensity" = 1; # compact
    "browser.tabs.inTitlebar" = 1;
    "browser.toolbars.bookmarks.visibility" = "never";
    "browser.uiCustomization.state" = builtins.toJSON toolbarLayout;

    # Sidebar
    "sidebar.verticalTabs" = true;
    "sidebar.main.tools" = "bookmarks,passwords";

    # Address bar
    "browser.urlbar.suggest.engines" = false;
    "browser.urlbar.suggest.quickactions" = false;
    "browser.urlbar.suggest.topsites" = false;

    # Bookmarks
    "browser.bookmarks.defaultLocation" = "menu________";
    "browser.bookmarks.showMobileBookmarks" = false;

    # Forms
    "extensions.formautofill.addresses.enabled" = false;
    "extensions.formautofill.creditCards.enabled" = false;

    # Network
    "network.dns.disablePrefetch" = true;
    "network.prefetch-next" = false;
    "network.http.speculative-parallel-limit" = 0;
    "network.http.referer.disallowCrossSiteRelaxingDefault.top_navigation" = true;
    "media.av1.enabled" = false;

    # Developer tools
    "devtools.accessibility.enabled" = false;
    "devtools.application.enabled" = false;
    "devtools.memory.enabled" = false;
    "devtools.performance.enabled" = false;
    "devtools.styleeditor.enabled" = false;
    "devtools.netmonitor.persistlog" = true;

    # Backups
    "browser.backup.scheduled.enabled" = true;
    "browser.backup.location" = "${homeDirectory}/Documents/Restore Firefox";

    # Privacy
    "privacy.globalprivacycontrol.enabled" = true;
    "dom.security.https_only_mode" = true;
    "network.trr.mode" = 3; # DNS over HTTPS only
    "network.trr.uri" = "https://mozilla.cloudflare-dns.com/dns-query";
    "privacy.fingerprintingProtection" = true;
    "media.autoplay.default" = 5; # block audio and video
    "signon.firefoxRelay.feature" = "disabled";
    "signon.management.page.breach-alerts.enabled" = false;

    # Language
    "intl.accept_languages" = "en-us,en,nl";
    "intl.regional_prefs.use_os_locales" = true;
    "browser.translations.neverTranslateLanguages" = "nl,en";

    "browser.disableResetPrompt" = true;
  };
in
{
  ExtensionSettings = lib.mapAttrs (_: forceInstall) extensionInstallUrls // {
    # Extensions installed by hand; managed ones need it in their own entry
    "*".default_area = "menupanel";
  };
  Preferences = lib.mapAttrs (_: applyOnEveryStart) preferences;

  DisableTelemetry = true;
  DisableFirefoxStudies = true;
  # Rollouts Mozilla pushes to change features remotely
  DisableRemoteImprovements = true;
  IPProtectionAvailable = false; # Firefox's own VPN; ProtonVPN covers it

  # Every AI feature off, except on-device translation
  AIControls = {
    Default = {
      Value = "blocked";
      Locked = true;
    };
    Translations.Value = "available";
  };
  VisualSearchEnabled = false;

  EnableTrackingProtection.Category = "strict";

  # No onboarding, tips or recommendations from Mozilla
  UserMessaging = {
    ExtensionRecommendations = false;
    FeatureRecommendations = false;
    FirefoxLabs = false;
    MoreFromMozilla = false;
    SkipOnboarding = true;
    UrlbarInterventions = false;
    WhatsNew = false;
    Locked = true;
  };
  # No Firefox Home: blank home page and new tab, and its content switched off
  Homepage = {
    URL = "about:blank";
    Locked = true;
  };
  NewTabPage = false;
  FirefoxHome = {
    Search = false;
    TopSites = false;
    SponsoredTopSites = false;
    Highlights = false;
    Stories = false;
    SponsoredStories = false;
    Weather = false;
    Locked = true;
  };
  FirefoxSuggest = {
    SponsoredSuggestions = false;
    ImproveSuggest = false;
  };
  # Proton Pass handles logins
  PasswordManagerEnabled = false;
  DisableFirefoxAccounts = true;

  Permissions = {
    Notifications.BlockNewRequests = true;
    Location.BlockNewRequests = true;
    VirtualReality.BlockNewRequests = true;
  };

  # Locked, because older per-item settings in the profile would override unlocked defaults
  SanitizeOnShutdown = {
    Cache = true;
    Cookies = true;
    Downloads = true;
    FormData = true;
    History = true;
  };

  # Same engine as terminal-browser
  SearchEngines = {
    Add = [
      {
        Name = "Ecosia";
        URLTemplate = "https://www.ecosia.org/search?q={searchTerms}";
        SuggestURLTemplate = "https://ac.ecosia.org/?q={searchTerms}";
      }
    ];
    Default = "Ecosia";
  };
}
