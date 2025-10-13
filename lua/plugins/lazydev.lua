return {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
        library = {
            { path = "snacks.nvim", words = { "Snacks" } },
        },
        integrations = {
            lspconfig = true,
            cmp = true,
        },
    },
}
