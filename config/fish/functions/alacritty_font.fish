function alacritty_font
    set font_size (math max $argv[1], 10);
    sed -i '' -E "s/size: [0-9]+/size: $font_size/g" $XDG_CONFIG_HOME/alacritty/alacritty.yml
end
