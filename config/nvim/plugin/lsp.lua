local lsp_path = vim.fs.joinpath(vim.fn.stdpath("config"), "lsp")
local lsps = {}
for fname, _ in vim.fs.dir(lsp_path) do
    lsps[#lsps + 1] = fname:match("^([^/]+)%.lua$")
end

vim.diagnostic.config({
    virtual_text = false,
    float = {
        border = "rounded",
        source = "if_many",
    },
})

vim.api.nvim_create_autocmd("CursorHold", {
    group = vim.api.nvim_create_augroup("UserDiagnostics", { clear = true }),
    callback = function()
        vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
    end,
})

-- Defer LSP setup until after the first file is displayed. vim.lsp.enable()
-- revisits buffers whose FileType event has already fired.
vim.api.nvim_create_autocmd("FileType", {
    once = true,
    callback = function()
        vim.schedule(function()
            vim.lsp.enable(lsps)
        end)
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            vim.notify(
                "LspAttach failed for client " .. args.data.client_id,
                vim.log.levels.WARN
            )
            return
        end

        if client:supports_method "textDocument/codeLens" then
            vim.lsp.codelens.enable(true, { bufnr = args.buf })
        end

        if client:supports_method "textDocument/inlayHint" then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end

        if client:supports_method "textDocument/documentColor" then
            vim.lsp.document_color.enable(true, { bufnr = args.buf })
        end

        if client:supports_method "textDocument/onTypeFormatting" then
            vim.lsp.on_type_formatting.enable(true, { client_id = client.id })
        end

        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end

        if client:supports_method("textDocument/inlineCompletion") then
            vim.lsp.inline_completion.enable(true, { bufnr = args.buf })

            vim.keymap.set("i", "<D-y>", function()
                if not vim.lsp.inline_completion.get() then
                    return "<D-y>"
                end
            end, { expr = true, replace_keycodes = true, buffer = args.buf, desc = "Accept inline completion" })

            vim.keymap.set("i", "<D-j>", function()
                vim.lsp.inline_completion.select({ count = 1 })
            end, { buffer = args.buf, desc = "Next inline completion" })

            vim.keymap.set("i", "<D-k>", function()
                vim.lsp.inline_completion.select({ count = -1 })
            end, { buffer = args.buf, desc = "Previous inline completion" })
        end


        -- Auto-format ("lint") on save.
        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        if
            not client:supports_method("textDocument/willSaveWaitUntil")
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
        vim.keymap.set("n", "gl", vim.diagnostic.open_float, vim.tbl_extend("force", bufopts, {
            desc = "Show line diagnostics",
        }))
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {
            desc = "Code Action",
        })

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
