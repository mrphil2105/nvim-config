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

        require("plugins.coq.config").setup()
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

        require("lsp_signature").setup {
            handler_opts = {
                border = "single",
            },
        }
    end,
}
