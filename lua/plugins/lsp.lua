return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "ray-x/lsp_signature.nvim",
    },
    config = function()
        local servers = require("plugins.lsp.servers")
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
        for server_name, settings in pairs(servers) do
            require("lspconfig")[server_name].setup {
                capabilities = capabilities,
                settings = settings,
                filetypes = settings.filetypes,
            }
        end
        require("typescript-tools").setup { capabilities = capabilities }
        require("lsp_signature").setup {
            handler_opts = {
                border = "single",
            },
        }
        require("plugins.lsp.ui").setup()
        require("plugins.lsp.avalonia").setup(capabilities)
        require("plugins.lsp.attach").setup()
        vim.lsp.enable("cssls")
    end,
}
