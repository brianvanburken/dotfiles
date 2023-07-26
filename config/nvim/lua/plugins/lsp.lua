return {
    "neovim/nvim-lspconfig",
    version = "~0.1",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "williamboman/mason.nvim", version = "~1.6.0" },
        { "williamboman/mason-lspconfig.nvim", version = "~1.11.0" },
        { "hrsh7th/cmp-nvim-lsp", commit = "44b16d11215dce86f253ce0c30949813c0a90765" },
        { "nvim-lua/plenary.nvim", version = "~0.1.0" },
        { "jose-elias-alvarez/null-ls.nvim", commit = "db09b6c691def0038c456551e4e2772186449f35" },
        { "jay-babu/mason-null-ls.nvim", version = "~2.1.0" },
    },
    config = function()
        local lsp = require("lspconfig")
        local nls = require("null-ls")
        local mason_null_ls = require("mason-null-ls")
        local cmp = require("cmp_nvim_lsp")

        require("mason").setup()
        require("mason-lspconfig").setup({
            automatic_installation = true,
        })

        local opts = { noremap = true, silent = true }
        vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, opts)

        local function lsp_mapping(buf)
            local bufopts = { buffer = buf, noremap = true, silent = true }

            vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)

            vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
            vim.keymap.set("n", "gh", vim.lsp.buf.hover, bufopts)
            vim.keymap.set("n", "gH", vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
            vim.keymap.set("n", "go", vim.lsp.buf.type_definition, bufopts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)

            vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, bufopts)
            vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, bufopts)

            vim.keymap.set("n", "<leader>lf", function()
                vim.lsp.buf.format({ async = true })
            end, bufopts)
        end

        -- https://github.com/numToStr/dotfiles/blob/master/neovim/.config/nvim/init.lua

        ---Common perf related flags for all the LSP servers
        local flags = {
            allow_incremental_sync = true,
        }

        ---Common capabilities including lsp snippets and autocompletion
        -- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
        local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

        ---Common `on_attach` function for LSP servers
        local function on_attach(client, buf)
            ---Disable formatting for servers (Handled by null-ls)
            ---@see https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false

            ---Disable |lsp-semantic_tokens| (conflicting with TS highlights)
            client.server_capabilities.semanticTokensProvider = nil

            ---LSP Mappings
            lsp_mapping(buf)
        end

        -- Disable LSP logging
        -- vim.lsp.set_log_level(vim.lsp.log_levels.OFF)

        -- Configuring native diagnostics
        vim.diagnostic.config({
            virtual_text = {
                source = "always",
            },
            float = {
                source = "always",
            },
        })

        local conf = {
            flags = flags,
            capabilities = capabilities,
            on_attach = on_attach,
        }

        local servers = {
            rust_analyzer = {
                flags = flags,
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                        },
                        checkOnSave = {
                            allFeatures = true,
                            command = "clippy",
                        },
                    },
                },
            },

            lua_ls = {
                flags = flags,
                capabilities = capabilities,
                on_attach = on_attach,
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
                            library = { os.getenv("VIMRUNTIME") },
                        },
                        -- Do not send telemetry data containing a randomized but unique identifier
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            },

            tsserver = {
                flags = flags,
                capabilities = capabilities,
                on_attach = on_attach,
                filetypes = {
                    "javascript",
                    "javascriptreact",
                    "javascript.jsx",
                    "typescript",
                    "typescriptreact",
                    "typescript.tsx",
                },
            },

            taplo = conf, -- TOML
            cssls = conf,
            elmls = conf,
            html = conf,
            jsonls = conf,
            yamlls = conf,
            tailwindcss = conf,
        }

        for server, configuration in pairs(servers) do
            lsp[server].setup(configuration)
        end

        local fmt = nls.builtins.formatting
        local dgn = nls.builtins.diagnostics
        local cda = nls.builtins.code_actions

        -- Configuring null-ls
        nls.setup({
            sources = {
                -- FORMATTING --
                fmt.elm_format,
                fmt.eslint_d,
                fmt.rustfmt,
                fmt.shfmt.with({ extra_args = { "-i", 4, "-ci", "-sr" } }),
                fmt.stylua,
                fmt.prettier,
                fmt.ymlfmt,
                fmt.trim_newlines.with({ filetypes = { "text", "markdown" } }),
                fmt.trim_whitespace.with({ disabled_filetypes = { "diff", "markdown" } }),

                -- DIAGNOSTICS --
                dgn.eslint_d,

                -- CODE ACTIONS --
                cda.eslint_d,
            },
            on_attach = function(client, buf)
                local fmt_group = vim.api.nvim_create_augroup("FORMATTING", { clear = true })
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = fmt_group,
                        buffer = buf,
                        callback = function()
                            vim.lsp.buf.format({
                                timeout_ms = 3000,
                                buffer = buf,
                            })
                        end,
                    })
                end

                lsp_mapping(buf)
            end,
        })

        mason_null_ls.setup({
            automatic_installation = true,
            handlers = {},
        })
    end,
}
