return {
    'echasnovski/mini.pick',
    keys = {
        { '<leader>ff', '<cmd>Pick files<cr>',     desc = 'Search files' },
        { '<leader>fg', '<cmd>Pick grep_live<cr>', desc = 'Search buffers' },
        { '<leader>fr', '<cmd>Pick resume<cr>',    desc = 'Resume previous search' },
    },
    config = function()
        local MiniPick = require("mini.pick")

        -- Override the 'files' picker to always use 'fd' as the tool
        MiniPick.registry.files = function(picker_opts)
            return MiniPick.builtin.files(vim.tbl_extend(
                "force",
                picker_opts or {},
                { tool = "fd" }
            ))
        end

        -- Setup mini.pick with the given options
        MiniPick.setup({
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
        )
    end,
}
