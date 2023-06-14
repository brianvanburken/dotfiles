function alacritty_font -d "Change the font size of alacritty"
    # Have a minimum of 10 to stay readable
    set font_size (math max $argv[1], 12);

    sed -i '' -E "s/size: [0-9]+/size: $font_size/g" $XDG_CONFIG_HOME/alacritty/alacritty.yml
end
