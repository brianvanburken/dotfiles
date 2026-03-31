vim.api.nvim_create_autocmd("LspAttach", {
    once = true,
    callback = function()
        vim.pack.add({ "https://github.com/linrongbin16/lsp-progress.nvim" })

        local lsp_progress = require("lsp-progress")
        lsp_progress.setup({
            format = function(client_messages)
                if #client_messages > 0 then
                    return " | " .. table.concat(client_messages, " ")
                end
                return ""
            end,
        })

        vim.o.statusline = "%f%<%m%r%{%v:lua.require('lsp-progress').progress()%}"

        vim.api.nvim_create_autocmd("User", {
            pattern = "LspProgressStatusUpdated",
            callback = function() vim.cmd("redrawstatus") end,
        })
    end,
})
