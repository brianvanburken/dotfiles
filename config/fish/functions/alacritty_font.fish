function alacritty_font
    sed -i '' -E "s/size: [0-9]+/size: $argv[1]/g" $XDG_CONFIG_HOME/alacritty/alacritty.yml
end
