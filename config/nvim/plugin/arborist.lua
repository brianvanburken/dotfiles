local loaded = false

local function load()
    if loaded then return end
    loaded = true
    vim.pack.add({ "https://github.com/arborist-ts/arborist.nvim" })
    require("arborist").setup({
        install_popular = false,
        update_cadence = "manual",
        prefer_wasm = false,
    })
end

-- Opened directly on a file: load before FileType fires so highlighting
-- applies to the first buffer.
vim.api.nvim_create_autocmd("BufReadPre", {
    once = true,
    callback = load,
})

-- Opened bare (e.g. `nvim` in a project, then picking a file via fff):
-- preload once nvim is idle so there's no delay on the first file open.
vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        vim.schedule(load)
    end,
})
