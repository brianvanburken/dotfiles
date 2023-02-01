function wm
    if test -n "$WORKING_MEMORY_FILE"
      set file "$WORKING_MEMORY_FILE"
    else
      set file "$HOME/Documents/wm.txt"
    end

    echo "\n$argv" >> "$file";
end
