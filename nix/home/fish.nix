{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Read-only, so `set -U` fails loudly; change nix/home/fish-variables.fish instead.
  # The interactive run first lets fish record its migration version.
  fishVariables = pkgs.runCommand "fish_variables" { nativeBuildInputs = [ pkgs.fish ]; } ''
    # No exported XDG_* variables, they would shadow the universal ones
    export HOME="$TMPDIR/home"
    fish --interactive --command exit
    fish ${./fish-variables.fish} ${lib.escapeShellArg config.home.homeDirectory}
    cp "$HOME/.config/fish/fish_variables" "$out"
  '';
in
{
  xdg.configFile."fish/fish_variables".source = fishVariables;
}
