return {
    cmd = function(dispatchers, config)
        local cmd = "biome"
        if config.root_dir then
            local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules", ".bin", cmd)
            if vim.fn.executable(local_cmd) == 1 then
                cmd = local_cmd
            end
        end
        return vim.lsp.rpc.start({ cmd, "lsp-proxy" }, dispatchers)
    end,
    filetypes = {
        "astro",
        "css",
        "graphql",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "jsonc",
        "svelte",
        "typescript",
        "typescriptreact",
        "vue",
    },
    root_markers = {
        "biome.json",
        "biome.jsonc",
    },
    workspace_required = true,
}
