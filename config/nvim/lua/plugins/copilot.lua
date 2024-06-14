return {
    "github/copilot.vim",
    event = { "InsertEnter" },
    version = "~1.34.0",
    config = function()
        vim.g.copilot_no_tab_map = true
        vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
            expr = true,
            replace_keycodes = false
        })
    end,
}
