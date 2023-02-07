function fish_prompt
    set_color blue
    echo -n (basename $PWD)
    set_color green
    echo -n ' 󰈺 '
end
