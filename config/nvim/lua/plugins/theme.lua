-- return {
--     "ellisonleao/gruvbox.nvim",
--     init = function()
--         vim.api.nvim_cmd({ cmd = "colorscheme", args = { "gruvbox" } }, {})
--     end,
--     opts = { contrast = "hard" },
-- }

return {
    "rose-pine/neovim",
    name = "rose-pine",
    init = function()
        vim.api.nvim_cmd({ cmd = "colorscheme", args = { "rose-pine" } }, {})
    end,
    opts = true,
}
