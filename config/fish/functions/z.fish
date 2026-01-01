function z --wraps __zoxide_z
    if not functions -q __zoxide_z
        zoxide init fish --no-cmd | source
    end
    __zoxide_z $argv
end
