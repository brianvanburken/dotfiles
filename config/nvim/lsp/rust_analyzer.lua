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
                -- importPrefix = "crate",
            },
            cargo = {
                extraEnv = { BUILD_ENV = "dev" },
                targetDir = true,
                features = "all",
                allFeatures = true,
                allTargets = false
            },
            check = {
                features = "all",
                command = "check",
            },
            inlayHints = {
                lifetimeElisionHints = {
                    enable = true,
                    useParameterNames = true,
                },
            },
            procMacro = {
                enable = true,
                ignored = {
                    ["async-trait"] = {},
                },
            },
            diagnostics = {
                disabled = { "inactive-code" },
            }
        },
    },
    root_markers = {
        "Cargo.toml",
    },
}
