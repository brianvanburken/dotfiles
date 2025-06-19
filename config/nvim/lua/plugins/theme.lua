return {
    "kdheepak/monochrome.nvim",
    priority = 1000,
    init = function()
        vim.g.monochrome_style = "amplified"
        vim.cmd.colorscheme "monochrome"
    end,
}
