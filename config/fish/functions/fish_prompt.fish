function fish_prompt
    # Must be captured before any command below overwrites it
    set -l last_status $status

    # Display the current directory
    set_color --bold
    echo -n (path basename $PWD)

    set -l environment_markers
    set -q DIRENV_DIR; and set -a environment_markers n

    if set -q environment_markers[1]
        set_color normal
        echo -n '('(string join '' $environment_markers)')'
    end

    if test $last_status -ne 0
        set_color --bold red
    else
        set_color normal
    end

    echo -n ' $ '

    # Reset the color to default
    set_color normal
end
