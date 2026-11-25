{ config, lib, pkgs, ... }:

let
  # Erlang writes ~/.erlang.cookie unless its user_config dir already has one.
  # That dir follows XDG_CONFIG_HOME on Linux but not on macOS.
  configDir =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "${config.home.homeDirectory}/Library/Application Support"
    else
      config.xdg.configHome;
  cookie = "${configDir}/erlang/.erlang.cookie";
in
{
  # Generated here, not linked from the store, because the cookie is a secret.
  home.activation.erlangCookie = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    cookie=${lib.escapeShellArg cookie}
    if [ ! -s "$cookie" ]; then
      run mkdir -p "$(dirname "$cookie")"
      run sh -c 'umask 077; LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c 20 >"$1"' _ "$cookie"
      run chmod 400 "$cookie"
    fi
  '';
}
