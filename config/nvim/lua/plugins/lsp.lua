return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "williamboman/mason.nvim", version = "~1.7.0" },
        { "williamboman/mason-lspconfig.nvim", version = "~1.14.0" },
        { "hrsh7th/cmp-nvim-lsp", commit = "44b16d11215dce86f253ce0c30949813c0a90765" },
        { "nvim-lua/plenary.nvim", version = "~0.1.0" },
        { "stevearc/conform.nvim", version = "~v5.3.0" },
    },
    config = function()
        local lsp = require("lspconfig")
        local conform = require("conform")
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
            if client.name ~= "rust_analyzer" then
                ---Disable formatting for servers (Handled by null-ls)
                ---@see https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
            end

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

        local servers = {
            rust_analyzer = {
                filetypes = {
                    "rust",
                },
                settings = {
                    ["rust-analyzer"] = {
                        rust = {
                            analyzerTargetDir = true,
                        },
                        assist = {
                            importEnforceGranularity = true,
                            importPrefix = "crate",
                        },
                        cargo = {
                            features = "all",
                        },
                        check = {
                            extraArgs = { "--target-dir", "/tmp/rust-analyzer" },
                            features = "all",
                            command = "clippy",
                        },
                        inlayHints = {
                            lifetimeElisionHints = {
                                enable = true,
                                useParameterNames = true,
                            },
                        },
                    },
                },
            },
            lua_ls = {
                filetypes = {
                    "lua",
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
            },
            ts_ls = {
                filetypes = {
                    "javascript",
                    "javascriptreact",
                    "javascript.jsx",
                    "typescript",
                    "typescriptreact",
                    "typescript.tsx",
                },
            },
            taplo = {
                filetypes = {
                    "toml",
                },
            },
            cssls = {
                filetypes = {
                    "css",
                    "scss",
                },
            },
            elmls = {
                filetypes = {
                    "elm",
                },
            },
            html = {
                filetypes = {
                    "html",
                    "css",
                    "scss",
                },
            },
            jsonls = {
                filetypes = {
                    "json",
                    "jsonc",
                },
            },
            yamlls = {
                filetypes = {
                    "yaml",
                },
            },
            tailwindcss = {
                filetypes = {
                    "html",
                    "css",
                    "scss",
                },
            },
            elixirls = {
                filetypes = { "elixir", "eelixir", "heex", "surface" },
                settings = {
                    elixirLS = {
                        dialyzerEnabled = false,
                        fetchDeps = false,
                    },
                },
            },
        }

        -- https://github.com/neovim/neovim/issues/30985
        for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
            local default_diagnostic_handler = vim.lsp.handlers[method]
            vim.lsp.handlers[method] = function(err, result, context, config)
                if err ~= nil and err.code == -32802 then
                    return
                end
                return default_diagnostic_handler(err, result, context, config)
            end
        end

        for server, conf in pairs(servers) do
            lsp[server].setup({
                flags = flags,
                capabilities = capabilities,
                on_attach = on_attach,
                settings = conf.settings,
                filetypes = conf.filetypes,
            })
        end

        -- Configuring conform
        local formatters = {
            ["*"] = { "trim_whitespace", "trim_newlines" },
            css = { { "stylelint", "prettierd" } },
            elixir = { "mix" },
            elm = { "elm_format" },
            graphql = { "prettierd" },
            html = { "prettierd" },
            javascript = { "prettierd" },
            javascriptreact = { "prettierd" },
            json = { "prettierd" },
            jsonc = { "prettierd" },
            lua = { { "stylua", "stylelua" } },
            markdown = { "prettierd" },
            rust = { "rustfmt" },
            scss = { { "stylelint", "prettierd" } },
            sh = { "shfmt" },
            toml = { "taplo" },
            typescript = { "prettierd" },
            typescriptreact = { "prettierd" },
            yaml = { "prettierd" },
        }

        conform.setup({
            formatters_by_ft = formatters,
            format_on_save = {
                timeout_ms = 3000,
                lsp_fallback = true,
            },
        })
    end,
}
