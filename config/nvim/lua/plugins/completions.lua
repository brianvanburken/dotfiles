-- Sources: https://vonheikemen.github.io/devlog/tools/setup-nvim-lspconfig-plus-nvim-cmp/
return {
    "hrsh7th/nvim-cmp",
    commit = "c4e491a87eeacf0408902c32f031d802c7eafce8",
    dependencies = {
        { "saadparwaiz1/cmp_luasnip", commit = "18095520391186d634a0045dacaa346291096566" },
        { "hrsh7th/cmp-path", commit = "91ff86cd9c29299a64f968ebb45846c485725f23" },
        { "hrsh7th/cmp-buffer", commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa" },
        { "L3MON4D3/LuaSnip", version = "~2.0.0" },
    },
    event = "BufReadPost",
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local select_opts = { behavior = cmp.SelectBehavior.Select }

        local aliases = {
            nvim_lsp = "lsp",
            luasnip = "snippet",
        }

        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ["<C-n>"] = cmp.mapping.select_next_item(select_opts),
                ["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-e>"] = cmp.config.disable,
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
                ["<C-d>"] = cmp.mapping(function(fallback)
                    if luasnip.jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<C-space>"] = cmp.mapping({
                    i = cmp.mapping.complete(),
                    c = function(
                        _ --[[fallback]]
                    )
                        if cmp.visible() then
                            if not cmp.confirm({ select = true }) then
                                return
                            end
                        else
                            cmp.complete()
                        end
                    end,
                }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    local col = vim.fn.col(".") - 1

                    if cmp.visible() then
                        cmp.select_next_item(select_opts)
                    elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
                        fallback()
                    else
                        cmp.complete()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item(select_opts)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp", max_item_count = 3 },
                { name = "luasnip", max_item_count = 3 },
                { name = "path", max_item_count = 3 },
                { name = "buffer", max_item_count = 3 },
            }),
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            formatting = {
                format = function(entry, item)
                    item.menu = string.format("[%s]", aliases[entry.source.name] or entry.source.name)
                    return item
                end,
            },
        })
    end,
}
