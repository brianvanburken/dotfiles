vim.api.nvim_create_user_command("StartupTime", function(args)
    vim.api.nvim_del_user_command("StartupTime")
    vim.pack.add({ "https://github.com/dstein64/vim-startuptime" })
    vim.api.nvim_cmd({
        cmd = "StartupTime",
        args = args.fargs,
        mods = args.smods,
    }, {})
end, { nargs = "*" })
