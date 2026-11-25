-- Parsers are installed by Nix (nix/home/neovim.nix); language.add()
-- fails for languages without one, such as fff_input.
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang or not vim.treesitter.language.add(lang) then return end

        vim.cmd.packadd("nvim-treesitter")
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        vim.treesitter.start(args.buf, lang)
    end,
})
