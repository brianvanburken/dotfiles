function load_mise
    set -l directory $PWD

    while true
        if path filter -q -f \
                "$directory"/{,.}mise{,.local}.toml \
                "$directory/.tool-versions"
            break
        end

        test "$directory" = /; and return
        set directory (path dirname "$directory")
    end

    command mise activate fish | source
    set -l activation_status $pipestatus
    test $activation_status[1] -eq 0; or return $activation_status[1]
    test $activation_status[2] -eq 0; or return $activation_status[2]

    functions -e __load_mise_on_cd
    functions -e __load_mise_on_first_command
    functions -e load_mise
end

function __load_mise_on_cd --on-variable PWD
    load_mise
end
