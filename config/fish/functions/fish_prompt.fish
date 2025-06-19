function fish_prompt
    # Display the current directory
    set_color --bold
    echo -n (basename $PWD)

    # Check the exit status of the last command
    # Set the color to bold red if there was an error
    if test $status -ne 0
        set_color --bold red
    else
        set_color normal
    end

    echo -n ' $ '

    # Reset the color to default
    set_color normal
end
