return {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        disable_frontmatter = true,
        ui = {
            enable = false,
        },
        new_notes_location = "00 Inbox",
        templates = {
            folder = "00 Templates",
        },
        daily_notes = {
            folder = "00 Inbox",
        },
        workspaces = {
            {
                name = "Personal",
                path = "/Volumes/Personal Data/",
            },
        },
    },
}
