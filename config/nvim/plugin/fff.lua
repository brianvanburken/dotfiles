vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        vim.pack.add({ "https://github.com/dmtrKovalenko/fff" })

        vim.g.fff = {
            lazy_sync = true,
            prompt = '',
            title = 'Files',
            layout = {
                prompt_position = 'top',
                preview_position = 'bottom',
                flex = { wrap = 'bottom' },
            }
        }

        vim.keymap.set("n", "<leader>ff", function() require("fff").find_files() end, {})
        vim.keymap.set("n", "<leader>fg", function() require("fff").live_grep() end, {})
        vim.keymap.set("n", "<leader>fr", function() require("fff").resume() end, {})
    end,
})

vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'fff.nvim' and (kind == 'install' or kind == 'update') then
            if not ev.data.active then vim.cmd.packadd('fff.nvim') end
            require('fff.download').download_or_build_binary()
        end
    end,
})
