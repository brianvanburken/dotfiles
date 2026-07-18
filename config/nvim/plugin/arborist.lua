vim.pack.add({ "https://github.com/arborist-ts/arborist.nvim" })
require("arborist").setup({
    install_popular = false,
    update_cadence = "manual",
    prefer_wasm = false,
})
