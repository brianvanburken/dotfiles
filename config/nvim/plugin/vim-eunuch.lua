local function load_eunuch(cmd, o)
    vim.pack.add({ "https://github.com/tpope/vim-eunuch" })
    vim.cmd(cmd .. (o.bang and "!" or "") .. " " .. o.args)
end

for _, cmd in ipairs({ "Remove", "Delete", "Unlink", "Move", "Rename", "Chmod", "Mkdir", "SudoEdit", "SudoWrite", "Wall", "W" }) do
    vim.api.nvim_create_user_command(cmd, function(o) load_eunuch(cmd, o) end, { nargs = "*", bang = true, complete = "file" })
end
