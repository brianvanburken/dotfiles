{
  # macOS's path_helper puts the system directories in front of Nix's
  programs.fish.shellInit = ''
    fish_add_path --global --move /run/current-system/sw/bin
  '';
}
