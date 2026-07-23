function load_mise
    path filter -q -f \
        "$PWD"/{,.}mise{,.local}.toml \
        "$PWD/.tool-versions" \
        "$PWD"/../{,.}mise{,.local}.toml \
        "$PWD/../.tool-versions"
    or return

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
