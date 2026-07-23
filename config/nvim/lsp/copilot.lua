---@param bufnr integer
---@param client vim.lsp.Client
local function sign_in(bufnr, client)
    client:request("signIn", vim.empty_dict(), function(err, result)
        if err then
            vim.notify(err.message, vim.log.levels.ERROR)
            return
        end

        if result.status == "PromptUserDeviceFlow" then
            vim.fn.setreg("+", result.userCode)
            vim.fn.setreg("*", result.userCode)
            vim.notify(
                "Copied code "
                    .. result.userCode
                    .. " to clipboard. Enter it at "
                    .. result.verificationUri
            )
        elseif result.status == "AlreadySignedIn" then
            vim.notify("Already signed in as " .. result.user .. ".")
        end
    end)
end

---@param client vim.lsp.Client
local function sign_out(_, client)
    client:request("signOut", vim.empty_dict(), function(err, result)
        if err then
            vim.notify(err.message, vim.log.levels.ERROR)
            return
        end

        if result.status == "NotSignedIn" then
            vim.notify("Not signed in.")
        end
    end)
end

return {
    cmd = { "copilot-language-server", "--stdio" },
    root_markers = { ".git" },
    init_options = {
        editorInfo = {
            name = "Neovim",
            version = tostring(vim.version()),
        },
        editorPluginInfo = {
            name = "Neovim",
            version = tostring(vim.version()),
        },
    },
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, "LspCopilotSignIn", function()
            sign_in(bufnr, client)
        end, { desc = "Sign in Copilot with GitHub" })
        vim.api.nvim_buf_create_user_command(bufnr, "LspCopilotSignOut", function()
            sign_out(bufnr, client)
        end, { desc = "Sign out Copilot with GitHub" })
    end,
}
