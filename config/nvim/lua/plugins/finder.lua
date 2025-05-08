return {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
        { "<leader>ff", "<cmd>FzfLua files<CR>" },
        { "<leader>fg", "<cmd>FzfLua live_grep<CR>" },
        { "<leader>fr", "<cmd>FzfLua resume<CR>" },
        { "<leader>fd", "<cmd>FzfLua diagnostics_document<CR>" },
        { "<leader>fs", "<cmd>FzfLua lsp_document_symbols<CR>" },
        { "<leader>fw", "<cmd>FzfLua lsp_workspace_symbols<CR>" },
        { "<leader>ft", "<cmd>FzfLua spell_suggest<CR>" },
    },
    opts = {
        "border-fused",
        fzf_colors = true,
        fzf_opts = {
            ['--no-scrollbar'] = true,
        },
        fzf_args = "--bind=change:first",
        defaults = {
            git_icons = false,
            file_icons = false,
            color_icons = false,
            formatter = "path.filename_first",
        },
        lsp = {
            symbols = {
                symbol_style = false
            }
        },
        files = {
            previewer  = false,
            cwd_prompt = false,
        },
        winopts = {
            border   = "single",
            backdrop = 100,
            preview  = {
                scrollbar = "none",
                title = false,
            }
        },
    }
}
