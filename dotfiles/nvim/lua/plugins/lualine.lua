return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        options = { theme = "tokyonight" },
        sections = {
            lualine_b = { "diff", "diagnostics" },
            lualine_c = { { "filename", path = 1 } },
        },
    },
}
