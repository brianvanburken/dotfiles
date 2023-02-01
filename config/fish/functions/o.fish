function o
    if test -n "$argv[1]"
      set location "$argv[1]"
    else
      set location "."
    end

    open "$location";
end
