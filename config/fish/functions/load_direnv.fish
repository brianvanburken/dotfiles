function load_direnv
    path filter -q -f "$PWD/.envrc" "$PWD/../.envrc"
    or return

    command direnv hook fish | source
    set -l activation_status $pipestatus
    test $activation_status[1] -eq 0; or return $activation_status[1]
    test $activation_status[2] -eq 0; or return $activation_status[2]

    functions -e __load_direnv_on_cd
    functions -e __load_direnv_on_first_command
    functions -e load_direnv
    __direnv_export_eval
end

function __load_direnv_on_cd --on-variable PWD
    load_direnv
end
