vim.env.FZF_CTRL_T_COMMAND = vim.env.FZF_DEFAULT_COMMAND
vim.env.FZF_ALT_C_COMMAND = vim.env.FZF_DEFAULT_COMMAND
vim.env.FZF_DEFAULT_OPTS = "--ansi"

vim.api.nvim_set_keymap("n", "<C-p>", ":Files!<CR>", {})
vim.api.nvim_set_keymap("n", "<C-a>", ":Rg!<CR>", {})
