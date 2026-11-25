{
  # macOS's path_helper puts the system directories in front of Nix's.
  # Sets PATH directly: fish_add_path costs ~0.6 ms of startup.
  programs.fish.shellInit = ''
    set -gx PATH /run/current-system/sw/bin (string match -v -- /run/current-system/sw/bin $PATH)
  '';
}
