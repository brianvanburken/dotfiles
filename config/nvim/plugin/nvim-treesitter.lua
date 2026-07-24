-- vim.treesitter.language.add() doubles as an availability check:
-- it succeeds if a parser is already loadable (bundled in core, or
-- previously installed), so we only fall through to installing when
-- it fails and the language is one we manage.
local function start_treesitter(bufnr, lang)
    if vim.api.nvim_buf_is_valid(bufnr) and vim.treesitter.language.add(lang) then
        vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        vim.treesitter.start(bufnr, lang)
        return true
    end
    return false
end

local plugin
local function treesitter()
    if not plugin then
        vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })
        plugin = require("nvim-treesitter")
    end
    return plugin
end


-- nvim-treesitter defines its own :TSUpdate once loaded, but until then
-- (e.g. every cached parser is already installed) the command doesn't
-- exist yet. This wrapper loads the plugin first, which redefines
-- :TSUpdate to the real implementation before we invoke it.
vim.api.nvim_create_user_command("TSUpdate", function()
    treesitter().update(nil, { summary = true }):wait(300000)
end, { desc = "Load nvim-treesitter and update installed parsers" })

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then return end

        if start_treesitter(args.buf, lang) then return end

        treesitter().install(lang):await(function(err)
            if err then return end
            vim.schedule(function() start_treesitter(args.buf, lang) end)
        end)
    end,
})
