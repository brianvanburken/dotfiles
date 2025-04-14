return {
    cmd = { "elixir-ls" },
    filetypes = { "elixir", "eelixir", "heex" },
    root_markers = { "mix.lock" },
    settings = {
        elixirLS = {
            dialyzerEnabled = false,
            fetchDeps = false,
        },
    },
}
