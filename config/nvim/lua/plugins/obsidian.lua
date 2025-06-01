local vault_location = "/Volumes/Personal Data"

return {
    "epwalsh/obsidian.nvim",
    event = {
        "BufReadPre " .. vault_location .. "/**.md",
        "BufNewFile " .. vault_location .. "/**.md",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        ui = {
            enabled = false
        },
        workspaces = {
            {
                name = "personal",
                path = vault_location
            },
        },
    },
}
