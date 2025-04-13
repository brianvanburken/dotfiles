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
            elixir = "html-eex",
            eelixir = "html-eex",
            heex = "html-eex",
        },
    },
    settings = {
        tailwindCSS = {
            classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
            includeLanguages = {
                eelixir = "html-eex",
                eruby = "erb",
                htmlangular = "html",
                templ = "html"
            },
            lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidConfigPath = "error",
                invalidScreen = "error",
                invalidTailwindDirective = "error",
                invalidVariant = "error",
                recommendedVariantOrder = "warning"
            },
            validate = true
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
