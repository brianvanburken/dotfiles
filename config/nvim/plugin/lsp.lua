vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        local lsp_path = vim.fs.joinpath(vim.fn.stdpath("config"), "lsp")
        local lsps = {}
        for fname, _ in vim.fs.dir(lsp_path) do
            lsps[#lsps + 1] = fname:match("^([^/]+).lua$")
        end
        vim.lsp.enable(lsps)
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end

        -- Auto-format ("lint") on save.
        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        if
            client
            and not client:supports_method("textDocument/willSaveWaitUntil")
            and client:supports_method("textDocument/formatting")
            and not vim.b[args.buf].format_autocmd_set
        then
            vim.b[args.buf].format_autocmd_set = true
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                end,
            })
        end

        local bufopts = { buffer = args.buf, noremap = true, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)

        local opts = { buffer = args.buf }
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        -- Apply first autocomplete item if omnifunc is open, else indent as normal
        vim.keymap.set("i", "<Tab>", function()
            if vim.fn.pumvisible() == 1 then
                return vim.api.nvim_replace_termcodes("<C-n><C-y>", true, true, true)
            else
                return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
            end
        end, { expr = true, silent = true })
    end,
})
-- https://github.com/neovim/nvim-lspconfig/blob/8adb3b5938f6074a1bcc36d3c3916f497d2e8ec4/plugin/lspconfig.lua#L68
vim.api.nvim_create_user_command("LspInfo", ":checkhealth vim.lsp", { desc = "Alias to `:checkhealth vim.lsp`" })

-- https://github.com/neovim/nvim-lspconfig/blob/8adb3b5938f6074a1bcc36d3c3916f497d2e8ec4/plugin/lspconfig.lua#L70C1-L74C3
vim.api.nvim_create_user_command("LspLog", function()
    vim.cmd(string.format("tabnew %s", vim.lsp.log.get_filename()))
end, { desc = "Opens the Nvim LSP client log." })


-- https://github.com/neovim/nvim-lspconfig/blob/8adb3b5938f6074a1bcc36d3c3916f497d2e8ec4/plugin/lspconfig.lua#L112
vim.api.nvim_create_user_command("LspRestart", function()
    local clients = vim.lsp.get_clients()
    local restarted = {}

    for _, active_client in pairs(clients) do
        if active_client.name and active_client.name ~= "copilot" then
            restarted[active_client.name] = active_client.config
            active_client.stop(true)
        end
    end

    vim.defer_fn(function()
        for _, config in pairs(restarted) do
            vim.lsp.start(config)
        end
        vim.notify("Restarted " .. vim.tbl_count(restarted) .. " LSP clients", vim.log.levels.INFO)
    end, 500)
end, { desc = "Restart the given client(s)" })
