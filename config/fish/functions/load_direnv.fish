function load_direnv
    path filter -q -f "$PWD/.envrc" "$PWD/../.envrc"
    or return

    __load_direnv_hook
    or return

    functions -e __load_direnv_on_cd __load_direnv_on_first_command __load_direnv_hook load_direnv
    __direnv_export_eval
end

function __load_direnv_hook
    set -l direnv_path (command -s direnv)
    or begin
        printf '%s\n' 'load_direnv: direnv not found' >&2
        return 127
    end
    set direnv_path (path resolve -- "$direnv_path")
    or return

    set -l cache_dir "$HOME/.cache/direnv"
    if string match -q '/*' -- "$XDG_CACHE_HOME"
        set cache_dir "$XDG_CACHE_HOME/direnv"
    end
    set -l cache_file "$cache_dir/"(string escape --style=var -- "$direnv_path")".fish"
    if test -s "$cache_file"; and not test "$direnv_path" -nt "$cache_file"
        source "$cache_file"
        return
    end

    set -l hook "$(command "$direnv_path" hook fish)"
    or return
    if test -z "$hook"
        printf '%s\n' 'load_direnv: direnv returned an empty hook' >&2
        return 1
    end
    printf '%s\n' "$hook" | source
    or return

    command mkdir -p -m 700 -- "$cache_dir"; or return 0
    set -l temp_file (command mktemp "$cache_dir/hook.XXXXXX"); or return 0
    printf '%s\n' "$hook" >"$temp_file"
    and command mv -f -- "$temp_file" "$cache_file"
    or command rm -f -- "$temp_file"
    return 0
end

function __load_direnv_on_cd --on-variable PWD
    load_direnv
end
