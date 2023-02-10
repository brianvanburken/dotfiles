function wm --d "Write to working memory file"
    if test -n "$WORKING_MEMORY_FILE"
      set file "$WORKING_MEMORY_FILE"
    else
      set file "$HOME/Documents/wm.txt"
    end

    echo -e "\n* [ ] $argv" >> "$file";
end
