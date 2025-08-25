return {
    cmd = { "tailwindcss-language-server" },
    filetypes = {
        "elixir",
        "eelixir",
        "heex",
        "html",
        "css",
        "scss",
    },
    init_options = {
        userLanguages = {
            elixir = "phoenix-heex",
            eelixir = "phoenix-heex",
            heex = "phoenix-heex",
        },
    },
    settings = {
        tailwindCSS = {
            validate = true,
            classAttributes = { "class", "className", "classList" },
            lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidConfigPath = "error",
                invalidScreen = "error",
                invalidTailwindDirective = "error",
                invalidVariant = "error",
                recommendedVariantOrder = "warning"
            },
            experimental = {
                classRegex = {
                    [[class:\s*"([^"]*)]],
                },
            },
        },
    },
    root_markers = {
        "tailwind.config.mjs",
        "tailwind.config.cjs",
        "tailwind.config.js",
        "tailwind.config.ts",
        "postcss.config.js",
        "config/tailwind.config.js",
        "assets/tailwind.config.js",
    },
}
