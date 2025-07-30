function mode_theme
    set system_theme (defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")
    if [ $system_theme = "Dark" ]
        set fish_theme "ayu Dark"
    else
        set fish_theme "ayu Light"
    end
    fish_config theme save "$fish_theme"
end
