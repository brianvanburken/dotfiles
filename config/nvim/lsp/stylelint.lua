return {
    cmd = { "stylelint-lsp", "--stdio" },
    filetypes = {
        "css",
        "html",
        "scss",
    },
    root_markers = {
        ".stylelintrc",
        ".stylelintrc.cjs",
        ".stylelintrc.js",
        ".stylelintrc.json",
        ".stylelintrc.mjs",
        ".stylelintrc.yaml",
        ".stylelintrc.yml",
        "package.json",
        "stylelint.config.cjs",
        "stylelint.config.js",
        "stylelint.config.mjs",
    },
}
