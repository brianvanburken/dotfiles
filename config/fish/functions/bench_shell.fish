# Benchmarks the current shell
function bench_shell;
    if test -n "$argv[1]"
      set shell "$argv[1]"
    else
      set shell "$SHELL"
    end

    if command -v hyperfine &> /dev/null;
        hyperfine --warmup 5 "$shell -i -c 'exit 0'"
    else
        for i in (seq 1 10); time "$shell" -i -c 'exit 0'; end
    end
end
