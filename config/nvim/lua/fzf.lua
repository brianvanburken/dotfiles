vim.env.FZF_CTRL_T_COMMAND = vim.env.FZF_DEFAULT_COMMAND
vim.env.FZF_ALT_C_COMMAND = vim.env.FZF_DEFAULT_COMMAND
vim.env.FZF_DEFAULT_OPTS = "--ansi"

require('fzf-lua').setup({
    winopts = {
        fullscreen = true
    }
})

vim.api.nvim_set_keymap('n', '<C-p>', "<cmd>lua require('fzf-lua').files()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-t>', "<cmd>lua require('fzf-lua').tags()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-a>', "<cmd>lua require('fzf-lua').live_grep()<CR>", { noremap = true, silent = true })
