return {
    "takac/vim-hardtime",
    event = "VeryLazy",
    init = function()
        vim.g.hardtime_default_on = 1
        vim.g.hardtime_showmsg = 1
        vim.g.hardtime_timeout = 1000
        vim.g.hardtime_maxcount = 1
        vim.g.hardtime_motion_with_count_resets = 1
    end,
}
