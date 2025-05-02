vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0

vim.o.autoread = true -- Automatically reload files changed outside of vim
vim.o.clipboard = "unnamedplus"
vim.o.cmdheight = 1
vim.o.expandtab = true
vim.o.fcs = vim.o.fcs .. "eob: " -- hide EndOfBuffer characters
vim.o.hidden = true
vim.o.inccommand = "split"       -- Show live preview of substitutions
vim.o.lazyredraw = true
vim.o.list = true
vim.o.nu = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.shiftwidth = 2
vim.o.shortmess = vim.o.shortmess .. "aoOstTWAIcqFS" -- Shorten all messages
vim.o.signcolumn = "yes"
vim.o.statusline = "%f%<%m%r"
vim.o.tabstop = 2
vim.o.termguicolors = true -- enable true colors support
vim.o.updatetime = 50
vim.o.winborder = "single"
vim.o.writebackup = false
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.wo.wrap = false

-- Map <leader> to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Move visually selected blocks to move up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor where it is when joining lines
vim.keymap.set("n", "J", "mzJ`z")

-- URL handling (custom for when netrw is disabled and don't provide functionality)
if vim.fn.has("mac") == 1 then
    vim.keymap.set("n", "gx", '<Cmd>call jobstart(["open", expand("<cfile>")], {"detach": v:true})<CR>')
elseif vim.fn.has("unix") == 1 then
    vim.keymap.set("n", "gx", '<Cmd>call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<CR>')
end

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
