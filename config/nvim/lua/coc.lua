vim.g.coc_global_extensions = {
    "coc-css",
    "coc-elixir",
    "coc-html",
    "coc-html-css-support",
    "coc-json",
    "coc-lua",
    "coc-prettier",
    "coc-eslint",
    "coc-rust-analyzer",
    "coc-tsserver"
}

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
vim.api.nvim_set_keymap("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
vim.api.nvim_set_keymap("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

-- GoTo code navigation.
vim.api.nvim_set_keymap("n", "gd", "<Plug>(coc-definition)", {silent = true})
vim.api.nvim_set_keymap("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
vim.api.nvim_set_keymap("n", "gi", "<Plug>(coc-implementation)", {silent = true})
vim.api.nvim_set_keymap("n", "gr", "<Plug>(coc-references)", {silent = true})

vim.api.nvim_set_keymap("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})

-- Use K to show documentation in preview window.
vim.api.nvim_set_keymap("n", "K", ":lua ShowDocumentation()<CR>", {silent = true})
function ShowDocumentation()
    local filetype = vim.bo.filetype
    if filetype == "vim" or filetype == "help" then
        vim.api.nvim_command("h " .. vim.fn.expand("<cword>"))
    elseif vim.call("coc#rpc#ready") then
        vim.fn.CocActionAsync("doHover")
    else
        vim.api.nvim_command("!" .. vim.bo.keywordprg .. " " .. vim.fn.expand("<cword>"))
    end
end
