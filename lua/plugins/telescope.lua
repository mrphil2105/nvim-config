return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("telescope").setup {}

        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
        vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
        vim.keymap.set("n", "<leader>fs", builtin.search_history, {})
        vim.keymap.set("n", "<leader>fc", builtin.git_bcommits, {})
    end,
}
