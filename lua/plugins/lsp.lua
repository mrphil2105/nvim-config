return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "ray-x/lsp_signature.nvim",
    },
    config = function()
        local servers = require("plugins.lsp.servers")
        local capabilities = require("blink.cmp").get_lsp_capabilities()
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
        local lsps = { "nixd", "eslint", "cssls" }
        for _, lsp in ipairs(lsps) do
            vim.lsp.enable(lsp)
        end
    end,
}
