return {
    "stevearc/oil.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local oil = require("oil")

        oil.setup {
            float = {
                padding = 4,
                border = "single",
            },
        }

        vim.keymap.set("n", "<leader>o", oil.open_float, { desc = "Open Oil Float" })
    end,
}
