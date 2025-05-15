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
                extraEnv = { BUILD_ENV = "dev" },
                targetDir = true,
                features = "all",
            },
            check = {
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
