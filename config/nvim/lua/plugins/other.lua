return {
    {
        "christoomey/vim-tmux-navigator",
        keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
    },
    { "AndrewRadev/splitjoin.vim", keys = { "gS", "gJ" } },
    { "tpope/vim-abolish", event = "BufReadPost" },
    { "tpope/vim-commentary", event = "BufReadPost" },
    { "tpope/vim-eunuch", cmd = { "Rename", "Remove", "Delete", "Move", "Mkdir" } },
    { "tpope/vim-surround", event = "BufReadPost" },
}
