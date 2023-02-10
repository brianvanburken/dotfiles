return {
    {
        "numToStr/Navigator.nvim",
        opts = true,
        keys = {
            { "<C-h>", "<cmd>NavigatorLeft<CR>" },
            { "<C-j>", "<cmd>NavigatorDown<CR>" },
            { "<C-k>", "<cmd>NavigatorUp<CR>" },
            { "<C-l>", "<cmd>NavigatorRight<CR>" },
        },
    },
    { "AndrewRadev/splitjoin.vim", keys = { "gS", "gJ" } },
    { "tpope/vim-abolish", event = "BufReadPost" },
    { "tpope/vim-commentary", event = "BufReadPost" },
    { "tpope/vim-eunuch", cmd = { "Rename", "Remove", "Delete", "Move", "Mkdir" } },
    { "tpope/vim-surround", event = "BufReadPost" },
}
