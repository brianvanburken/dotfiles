return {
    "neovim/nvim-lspconfig",
    event = "BufRead",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "nvim-lua/plenary.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "sumneko_lua",
                "rust_analyzer",
                "cssls",
                "elmls",
                "html",
                "jsonls",
                "yamlls",
                "taplo",
                "tsserver",
            },
        })

        local function lsp_mapping(buf)
            local opts = { buffer = buf }
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, opts)
            vim.keymap.set("n", "]g", vim.diagnostic.goto_next, opts)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
            vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
            vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

            vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
            vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
            vim.keymap.set("x", "<leader>la", vim.lsp.buf.range_code_action, opts)
        end

        -- https://github.com/numToStr/dotfiles/blob/master/neovim/.config/nvim/init.lua
        local lsp = require("lspconfig")

        ---Common perf related flags for all the LSP servers
        local flags = {
            allow_incremental_sync = true,
            debounce_text_changes = 200,
        }

        ---Common capabilities including lsp snippets and autocompletion
        -- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        ---Common `on_attach` function for LSP servers
        ---@param client table
        ---@param buf integer
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

            sumneko_lua = {
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
                        diagnostics = {
                            globals = { "vim" },
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
        }

        for server, configuration in pairs(servers) do
            lsp[server].setup(configuration)
        end

        local nls = require("null-ls")

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
                fmt.trim_whitespace.with({ filetypes = { "text", "zsh", "toml", "make", "conf", "tmux" } }),

                -- DIAGNOSTICS --
                dgn.codespell,
                dgn.commitlint,
                dgn.eslint_d,
                dgn.luacheck.with({ extra_args = { "--globals", "vim", "--std", "luajit" } }),
                dgn.shellcheck,

                -- CODE ACTIONS --
                cda.eslint_d,
                cda.shellcheck,
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
    end,
}
