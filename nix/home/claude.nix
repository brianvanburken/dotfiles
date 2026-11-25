{ config, pkgs, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfreePredicate = pkgs.config.allowUnfreePredicate;
  };
in
{
  programs.claude-code = {
    enable = true;
    package = unstable.claude-code;
    configDir = "${config.xdg.configHome}/claude";
    context = ./claude/CLAUDE.md;
    plugins = [ inputs.mattpocock-skills ];

    # Read-only: changes made from inside Claude Code are lost on the next switch
    settings = {
      attribution = {
        commit = "";
        pr = "";
      };
      permissions.deny = [
        "NotebookEdit"
        "DesignSync"
        "CronCreate"
        "CronDelete"
        "CronList"
        "PushNotification"
        "RemoteTrigger"
        "Bash(git push *)"
        "Bash(rm *)"
        "Bash(rmdir *)"
      ];
      model = "opus";
      disableClaudeAiConnectors = true;
      disableBundledSkills = true;
      disableRemoteControl = true;
      disableWorkflows = true;
      disableArtifact = true;
      statusLine = {
        type = "command";
        command = "${./claude/statusline-command.sh}";
      };
      enabledPlugins."cc-plugin-plugin-authoring@builtin" = false;
      outputStyle = "Concise";
      spinnerTipsEnabled = false;
      tui = "fullscreen";
      theme = "auto";
      preferredNotifChannel = "terminal_bell";
    };
  };
}
