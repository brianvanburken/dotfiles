function fish_prompt
    # Display the current directory
    echo -n (basename $PWD)

    # Check the exit status of the last command
    if test $status -ne 0
        # Set the color to bold red if there was an error
        set_color --bold red
    else
        # Set the color to bold default if the last command was successful
        set_color --bold white
    end

    echo -n ' > '

    # Reset the color to default
    set_color normal
end
