return {
    {
        "mason-org/mason.nvim",
        event = "BufReadPost",
        opts = {
            ensure_installed = {
                "biome",
                "css-lsp",
                "elm-format",
                "elm-language-server",
                "expert",
                "html-lsp",
                "lua-language-server",
                "rust-analyzer",
                "tailwindcss-language-server",
                "taplo",
                "typescript-language-server",
                "vscode-json-language-server",
                "yaml-language-server",
            },
        }
    },
    {
        'linrongbin16/lsp-progress.nvim',
        event = "LspAttach",
        config = function()
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
    }
}
