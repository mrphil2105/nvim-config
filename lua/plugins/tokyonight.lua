return {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
        require("tokyonight").setup {
            on_colors = function(colors) colors.fg_gutter = "#555f8d" end,
        }
        vim.cmd([[colorscheme tokyonight-night]])
    end,
}
