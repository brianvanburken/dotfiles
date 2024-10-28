return {
    "folke/todo-comments.nvim",
    version = "~1.1.0",
    -- event = "BufReadPost",
    cmd = { "TodoComments", "TodoTelescope" },
    dependencies = {
        { "nvim-lua/plenary.nvim", version = "~0.1.3" },
    },
    keys = {
        { "]t", "<cmd>lua require('todo-comments').jump_next()<CR>" },
        { "[t", "<cmd>lua require('todo-comments').jump_prev()<CR>" },
    },
    opts = true,
}
