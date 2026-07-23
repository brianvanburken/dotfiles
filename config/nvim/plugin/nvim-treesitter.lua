local languages = {
    "bash",
    "css",
    "eex",
    "elixir",
    "elm",
    "fish",
    "haskell",
    "heex",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
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
}

local language_set = {}
for _, lang in ipairs(languages) do
    language_set[lang] = true
end

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

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then return end

        if start_treesitter(args.buf, lang) then return end
        if not language_set[lang] then return end

        vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })
        require("nvim-treesitter").install(lang):await(function(err)
            if err then return end
            vim.schedule(function() start_treesitter(args.buf, lang) end)
        end)
    end,
})
