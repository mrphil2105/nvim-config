return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "folke/trouble.nvim",
    },
    config = function()
        local open_with_trouble = require("trouble.sources.telescope").open
        require("telescope").setup {
            defaults = {
                mappings = {
                    i = { ["<C-t>"] = open_with_trouble },
                    n = { ["<C-t>"] = open_with_trouble },
                },
            },
        }

        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
        vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
        vim.keymap.set("n", "<leader>fs", builtin.search_history, {})
        vim.keymap.set("n", "<leader>fc", builtin.git_bcommits, {})
        vim.keymap.set("n", "<leader>fr", builtin.resume, {})
    end,
}
