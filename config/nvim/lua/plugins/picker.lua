return {
    'echasnovski/mini.pick',
    keys = {
        { '<leader>ff', '<cmd>Pick files<cr>',     desc = 'Search files' },
        { '<leader>fg', '<cmd>Pick grep_live<cr>', desc = 'Search buffers' },
        { '<leader>fr', '<cmd>Pick resume<cr>',    desc = 'Resume previous search' },
    },
    opts = function()
        local MiniPick = require("mini.pick")

        return {
            source = {
                show = MiniPick.default_show
            },
            options = {
                use_cache           = true,
                content_from_bottom = true,
            },
            window = {
                config = {
                    -- use entire editor width
                    width = vim.o.columns,
                    -- start at left edge
                    col = 0,
                },
            },
        }
    end,
}
