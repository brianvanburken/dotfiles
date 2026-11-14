# Startup optimisation: shadows fish's built-in fish_config.
#
# Fish's embedded config.fish runs `fish_config theme choose default --no-override`
# for every interactive shell, with no setting to disable it (~2.8 ms of ~11.6 ms
# startup, measured on fish 4.9.3). That call only fills in color variables that
# are still unset, and the universal variables written by
# `fish_config theme save ayu` (see setup_fish) already cover all of them, so it
# is skipped here.
#
# Every other invocation loads the real fish_config, which replaces this
# function for the rest of the session, and is forwarded to it.
#
# Depends on fish internals:
# - If fish changes the arguments of that startup call, the check below stops
#   matching and startup silently returns to stock speed. Nothing breaks.
# - If a fish release adds new color variables, they stay unset until
#   `fish_config theme save ayu` is run again.
#
# Verify it still works: `fish --profile-startup /tmp/startup.prof -i -c exit`
# and check that the `fish_config theme choose default` line costs ~0.
function fish_config --description "Launch fish's web based configuration"
    if test "$argv" = "theme choose default --no-override"
        return
    end

    status get-file functions/fish_config.fish | source
    fish_config $argv
end
