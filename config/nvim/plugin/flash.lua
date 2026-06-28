vim.api.nvim_create_autocmd("BufReadPost", {
    once = true,
    callback = function()
        vim.pack.add({ "https://github.com/folke/flash.nvim" })
        local ok, flash = pcall(require, "flash")
        if not ok then return end
        flash.setup()

        vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
        vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end,
            { desc = "Flash Treesitter" })
        vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
        vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end,
            { desc = "Treesitter Search" })
    end,
})
