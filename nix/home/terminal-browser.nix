{ pkgs, ... }:

{
  # Read-only: changes made from inside terminal-browser are lost on the next switch
  xdg.configFile."terminal-browser/settings.json".source =
    (pkgs.formats.json { }).generate "settings.json"
      {
        "search.engine" = "https://www.ecosia.org/search?q=%s";
        "search.suggestions" = "https://ac.ecosia.org/?q=%s";
        "telemetry.usage" = "off";
        "telemetry.crashReports" = "off";
        "updates.check" = "off";
      };
}
