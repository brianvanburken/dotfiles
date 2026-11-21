return {
    cmd = { "oxlint", "--lsp" },
    filetypes = {
        "astro",
        "javascript",
        "javascriptreact",
        "svelte",
        "typescript",
        "typescriptreact",
        "vue",
    },
    root_markers = {
        ".oxlintrc.json",
        ".oxlintrc.jsonc",
        "oxlint.config.ts",
    },
    workspace_required = true,
}
