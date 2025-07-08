function o --description "Open a file or directory passed or current directory"
    if test -n "$argv[1]"
      set location "$argv[1]"
    else
      set location "."
    end

    if type -q xdg-open
        xdg-open $target
    else if type -q open
        open $target
    else
        echo "Error: no opener found (tried xdg-open and open)"
        return 1
    end
end
