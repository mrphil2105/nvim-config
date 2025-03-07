return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "ray-x/lsp_signature.nvim",
    },
    config = function()
        local servers = require("plugins.lsp.servers")
        require("mason").setup {
            registries = {
                "github:mason-org/mason-registry",
                "github:crashdummyy/mason-registry",
            },
        }
        require("mason-lspconfig").setup {
            ensure_installed = vim.tbl_keys(servers),
        }
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
        require("mason-lspconfig").setup_handlers {
            function(server_name)
                local config = {
                    capabilities = capabilities,
                    settings = servers[server_name],
                    filetypes = (servers[server_name] or {}).filetypes,
                }
                if server_name == "ts_ls" then
                    require("typescript-tools").setup(config)
                elseif server_name ~= "roslyn" then
                    require("lspconfig")[server_name].setup(config)
                end
            end,
        }
        require("lsp_signature").setup {
            handler_opts = {
                border = "single",
            },
        }
        require("plugins.lsp.ui").setup()
        require("plugins.lsp.avalonia").setup(capabilities)
        require("plugins.lsp.attach").setup()
    end,
}
