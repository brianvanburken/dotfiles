return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    -- Sets the "root directory" to the parent directory of the file in the
    -- current buffer that contains either a ".luarc.json" or a
    -- ".luarc.jsonc" file. Files that share a root directory will reuse
    -- the connection to the same LSP server.
    root_markers = {
        '.luarc.json',
        '.luarc.jsonc',
        '.stylua.toml'
    },
    settings = {
        Lua = {
            completion = {
                enable = true,
                showWord = "Disable",
            },
            runtime = {
                -- LuaJIT in the case of Neovim
                version = "LuaJIT",
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME },
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}
