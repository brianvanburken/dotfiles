function multicd --d "Replaces each dot with a ../ for walking up the directory tree"
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
