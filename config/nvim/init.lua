vim.loader.enable()

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0

vim.o.autoread = true -- Automatically reload files changed outside of vim
vim.o.clipboard = "unnamedplus"
vim.o.cmdheight = 1
vim.o.fcs = vim.o.fcs .. "eob: " -- hide EndOfBuffer characters
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.inccommand = "split" -- Show live preview of substitutions
vim.o.lazyredraw = true
vim.o.list = true
vim.o.nu = true
vim.o.shortmess = vim.o.shortmess .. "aoOstTWAIcqFS" -- Shorten all messages
vim.o.signcolumn = "yes"
vim.o.statusline = "%f%<%m%r"
vim.o.termguicolors = true -- enable true colors support
vim.o.updatetime = 250
vim.o.winborder = "single"
vim.o.writebackup = false
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.wo.wrap = false

-- Handling of whitespace
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2

-- Map <leader> to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Move visually selected blocks to move up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor where it is when joining lines
vim.keymap.set("n", "J", "mzJ`z")

-- Function to open a target given based on OS
local function open_target(target)
    if vim.fn.has("mac") == 1 then
        vim.fn.jobstart({ "open", target }, { detach = true })
    else
        vim.fn.jobstart({ "xdg-open", target }, { detach = true })
    end
end

-- Open the URL under the cursor
-- For when netrw is disabled and don't provide functionality
vim.keymap.set("n", "gx", function()
    open_target(vim.fn.expand("<cfile>"))
end, { desc = "Open file/URL under cursor" })

-- Open the current open file
vim.api.nvim_create_user_command("Open", function()
    open_target(vim.fn.expand("%:p"))
end, { desc = "Open current file" })

-- Setting up LSP
-- Get all LSPs from the config directory and load them
local lsp_path = vim.fs.joinpath(vim.fn.stdpath("config"), "lsp")
local lsps = {}
for fname, _ in vim.fs.dir(lsp_path) do
    lsps[#lsps + 1] = fname:match("^([^/]+).lua$")
end
vim.lsp.enable(lsps)

-- Configuring native diagnostics
vim.diagnostic.config({
    float = { border = "rounded" },
    underline = true,
    virtual_text = true,
    virtual_lines = false,
})

-- Setup autompletion
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        -- Enable completion
        if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end

        -- Auto-format ("lint") on save.
        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        if
            client
            and not client:supports_method("textDocument/willSaveWaitUntil")
            and client:supports_method("textDocument/formatting")
        then
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                end,
            })
        end

        -- Keymaps
        local bufopts = { buffer = args.buf, noremap = true, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)

        local opts = { buffer = args.buf }
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>cf", function()
            vim.lsp.buf.format({ async = true })
        end, opts)

        -- Apply first autocomplete item if omnifunc is open, else indent as normal
        vim.keymap.set("i", "<Tab>", function()
            if vim.fn.pumvisible() == 1 then
                -- select the first item (with <C-n>) then accept it (<C-y>)
                return vim.api.nvim_replace_termcodes("<C-n><C-y>", true, true, true)
            else
                -- real Tab key (respects expandtab/shiftwidth)
                return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
            end
        end, { expr = true, silent = true })

        -- https://github.com/neovim/nvim-lspconfig/blob/8adb3b5938f6074a1bcc36d3c3916f497d2e8ec4/plugin/lspconfig.lua#L68
        vim.api.nvim_create_user_command('LspInfo', ':checkhealth vim.lsp', { desc = 'Alias to `:checkhealth vim.lsp`' })

        -- https://github.com/neovim/nvim-lspconfig/blob/8adb3b5938f6074a1bcc36d3c3916f497d2e8ec4/plugin/lspconfig.lua#L70C1-L74C3
        vim.api.nvim_create_user_command('LspLog', function()
            vim.cmd(string.format('tabnew %s', vim.lsp.get_log_path()))
        end, { desc = 'Opens the Nvim LSP client log.', })

        -- https://github.com/neovim/nvim-lspconfig/blob/8adb3b5938f6074a1bcc36d3c3916f497d2e8ec4/plugin/lspconfig.lua#L112
        vim.api.nvim_create_user_command('LspRestart', function(info)
            for _, name in ipairs(info.fargs) do
                if vim.lsp.config[name] == nil then
                    vim.notify(("Invalid server name '%s'"):format(info.args))
                else
                    vim.lsp.enable(name, false)
                end
            end

            local timer = assert(vim.uv.new_timer())
            timer:start(500, 0, function()
                for _, name in ipairs(info.fargs) do
                    vim.schedule_wrap(function(x)
                        vim.lsp.enable(x)
                    end)(name)
                end
            end)
        end, { desc = 'Restart the given client(s)', })
    end,
})

-- Setup Lazy.nvim
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")

require("lazy").setup("plugins", {
    defaults = { lazy = true },
    debug = false,
    change_detection = { notify = false },
    performance = {
        rtp = {
            disabled_plugins = {
                "2html_plugin",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logipat",
                "man",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "osc52",
                "rplugin",
                "rrhelper",
                "shada",
                "spellfile",
                "tarPlugin",
                "tohtml",
                "tutor",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
            },
        },
    },
})
