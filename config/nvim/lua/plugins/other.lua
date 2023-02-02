return {
    {
        "folke/todo-comments.nvim",
        cmd = "TodoTelescope",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            {"]t", "<cmd>lua require('todo-comments').jump_next()<CR>"},
            {"[t", "<cmd>lua require('todo-comments').jump_prev()<CR>"},
        },
        opts = true,
    },
    {
        "christoomey/vim-tmux-navigator",
        keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
    },
    { "AndrewRadev/splitjoin.vim", event = "BufReadPost" },
    { "tpope/vim-abolish", event = "BufReadPost" },
    { "tpope/vim-commentary", event = "BufReadPost" },
    { "tpope/vim-eunuch", cmd = { "Rename", "Remove", "Delete", "Move", "Mkdir" } },
    { "tpope/vim-surround", event = "BufReadPost" },
}
