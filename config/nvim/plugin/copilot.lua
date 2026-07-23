vim.api.nvim_create_autocmd("InsertEnter", {
    once = true,
    callback = function()
        if vim.fn.executable("node") ~= 1 then return end
        vim.pack.add({ "https://github.com/zbirenbaum/copilot.lua" })
        require("copilot").setup({
            panel = {
                enabled = false,
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                hide_during_completion = true,
                keymap = {
                    accept = "<D-y>",
                    next = "<D-j>",
                    prev = "<D-k>",
                    dismiss = "<C-c>",
                },
            },
            server_opts_overrides = {},
        })
    end,
})
