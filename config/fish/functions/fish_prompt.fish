function fish_prompt
    # Must be captured before any command below overwrites it
    set -l last_status $status

    # Display the current directory
    set_color --bold
    echo -n (path basename $PWD)

    if set -q __MISE_SESSION
        set_color normal
        echo -n '(m)'
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
