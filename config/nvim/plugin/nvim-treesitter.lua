vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        if not package.loaded["nvim-treesitter"] then
            vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })
            local nts = require("nvim-treesitter")
            nts.install({
                "bash",
                "css",
                "eex",
                "elixir",
                "elm",
                "fish",
                "heex",
                "html",
                "javascript",
                "jsdoc",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "nix",
                "regex",
                "ruby",
                "rust",
                "scss",
                "sql",
                "toml",
                "tsx",
                "typescript",
                "vim",
                "yaml",
            })
            vim.api.nvim_create_autocmd("PackChanged", {
                callback = function() nts.update() end,
            })
        end
        local lang = vim.treesitter.language.get_lang(args.match)
        if lang and vim.treesitter.language.add(lang) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            vim.treesitter.start()
        end
    end,
})
