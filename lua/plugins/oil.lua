return {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        float = { padding = 4, border = "single" },
        confirmation = { border = "single" },
        progress = { border = "single" },
        ssh = { border = "single" },
        keymaps_help = { border = "single" },
    },
    keys = {
        { "<leader>o", function() require("oil").open_float() end, desc = "Open Oil Float" },
    },
}
