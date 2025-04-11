return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    version = "~v1.8.0",
    dependencies = {
        { "williamboman/mason.nvim", version = "~1.7.0" },
        { "williamboman/mason-lspconfig.nvim", version = "~1.14.0" },
        { "nvim-lua/plenary.nvim", version = "~0.1.0" },
        { "stevearc/conform.nvim", version = "~v5.3.0" },
    },
    config = function()
        local lsp = require("lspconfig")
        local conform = require("conform")

        require("mason").setup()
        require("mason-lspconfig").setup({
            automatic_installation = true,
        })

        local function lsp_mapping(buf)
            local bufopts = { buffer = buf, noremap = true, silent = true }

            vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)

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
                    "elixir",
                    "eelixir",
                    "heex",
                    "html",
                    "css",
                    "scss",
                },
                init_options = {
                    userLanguages = {
                        elixir = "html-eex",
                        eelixir = "html-eex",
                        heex = "html-eex",
                    },
                },
                settings = {
                    tailwindCSS = {
                        experimental = {
                            classRegex = {
                                "(?:class:[\\s\\n]*|class=)['\"]([^'\"]+)['\"]",
                            },
                        },
                    },
                },
                root_dir = function(fname)
                    local root_pattern = lsp.util.root_pattern(
                        "tailwind.config.mjs",
                        "tailwind.config.cjs",
                        "tailwind.config.js",
                        "tailwind.config.ts",
                        "postcss.config.js",
                        "config/tailwind.config.js",
                        "assets/tailwind.config.js"
                    )
                    return root_pattern(fname)
                end,
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
                on_attach = on_attach,
                settings = conf.settings,
                filetypes = conf.filetypes,
            })
        end

        -- Configuring conform
        local formatters = {
            ["*"] = { "trim_whitespace", "trim_newlines" },
            css = { { "stylelint", "prettierd", "biome" } },
            elixir = { "mix" },
            elm = { "elm_format" },
            graphql = { "prettierd" },
            html = { "prettierd" },
            javascript = { "prettierd", "biome" },
            javascriptreact = { "prettierd", "biome" },
            json = { "prettierd", "biome" },
            jsonc = { "prettierd", "biome" },
            lua = { { "stylua", "stylelua" } },
            markdown = { "prettierd", "biome" },
            rust = { "rustfmt" },
            scss = { { "stylelint", "prettierd" } },
            sh = { "shfmt" },
            toml = { "taplo" },
            typescript = { "prettierd", "biome" },
            typescriptreact = { "prettierd", "biome" },
            yaml = { "prettierd" },
        }

        conform.setup({
            formatters_by_ft = formatters,
            format_on_save = {
                timeout_ms = 3000,
                lsp_fallback = true,
            },
        })

        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(ev)
                local client = vim.lsp.get_client_by_id(ev.data.client_id)
                if client and client:supports_method("textDocument/completion") then
                    vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
                end
            end,
        })
    end,
}
