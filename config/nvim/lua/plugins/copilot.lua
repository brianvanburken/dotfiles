return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("copilot").setup({
            suggestion = {
                auto_trigger = true,
                keymap = {
                    accept = "<C-J>",
                },
            }
        })
    end,
}
