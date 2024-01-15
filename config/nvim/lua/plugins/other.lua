return {
    {
        "christoomey/vim-tmux-navigator",
        keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
    },
    { "AndrewRadev/splitjoin.vim", version = "~1.2.0", keys = { "gS", "gJ" } },
    { "tpope/vim-abolish", commit = "cb3dcb220262777082f63972298d57ef9e9455ec", event = "BufReadPost" },
    { "tpope/vim-commentary", commit = "e87cd90dc09c2a203e13af9704bd0ef79303d755", event = "BufReadPost" },
    {
        "tpope/vim-eunuch",
        commit = "67f3dd32b4dcd1c427085f42ff5f29c7adc645c6",
        cmd = { "Rename", "Remove", "Delete", "Move", "Mkdir", "Copy" },
    },
    { "tpope/vim-surround", commit = "3d188ed2113431cf8dac77be61b842acb64433d9", event = "BufReadPost" },
}
