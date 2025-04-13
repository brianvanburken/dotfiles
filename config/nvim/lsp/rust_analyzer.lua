return {
    cmd = { "rust-analyzer" },
    filetypes = {
        "rust",
    },
    settings = {
        ["rust-analyzer"] = {
            rust = {
                analyzerTargetDir = true,
            },
            assist = {
                importEnforceGranularity = true,
                importPrefix = "crate",
            },
            cargo = {
                features = "all",
            },
            check = {
                extraArgs = { "--target-dir", "/tmp/rust-analyzer" },
                features = "all",
                command = "clippy",
            },
            inlayHints = {
                lifetimeElisionHints = {
                    enable = true,
                    useParameterNames = true,
                },
            },
        },
    },
    root_markers = {
        "Cargo.toml",
    },
}
