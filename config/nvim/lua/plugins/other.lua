return {
    {
        "gregorias/coerce.nvim",
        tag = 'v3.0.0',
        event = "BufReadPost",
        config = true,
    },
    {
        "tpope/vim-eunuch",
        commit = "67f3dd32b4dcd1c427085f42ff5f29c7adc645c6",
        cmd = { "Rename", "Remove", "Delete", "Move", "Mkdir", "Copy" },
    },
    { "tpope/vim-surround", commit = "3d188ed2113431cf8dac77be61b842acb64433d9", event = "BufReadPost" },
}
