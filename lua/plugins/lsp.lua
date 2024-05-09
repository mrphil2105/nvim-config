return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "ray-x/lsp_signature.nvim",
        "folke/neodev.nvim",
    },
    config = function()
        local servers = require("plugins.lsp.servers")
        local on_attach = require("plugins.lsp.attach")

        local configs = require("lspconfig.configs")
        local root_pattern = require("lspconfig.util").root_pattern
        if not configs.avalonia then
            configs.avalonia = {
                default_config = {
                    cmd = {
                        "dotnet",
                        "/home/mrphil2105/CSharp Projects/AvaloniaVSCode/src/AvaloniaLSP/AvaloniaLanguageServer/bin/Debug/net8.0/AvaloniaLanguageServer.dll",
                    },
                    root_dir = root_pattern("*.sln"),
                    filetypes = { "axaml", "xml" },
                },
            }
        end

        local coq = require("coq")

        require("mason").setup {}
        require("neodev").setup {
            library = {
                plugins = { "nvim-dap-ui" },
                types = true,
            },
        }

        require("mason-lspconfig").setup {
            ensure_installed = vim.tbl_keys(servers),
        }

        require("mason-lspconfig").setup_handlers {
            function(server_name)
                require("lspconfig")[server_name].setup(coq.lsp_ensure_capabilities {
                    on_attach = on_attach,
                    settings = servers[server_name],
                    filetypes = (servers[server_name] or {}).filetypes,
                })
            end,
        }
        require("lspconfig").avalonia.setup(coq.lsp_ensure_capabilities {
            on_attach = on_attach,
            settings = {},
        })

        require("lsp_signature").setup {
            handler_opts = {
                border = "single",
            },
        }

        vim.keymap.set("i", "<C-y>", vim.lsp.buf.completion)
        require("plugins.lsp.ui").setup()
    end,
}
