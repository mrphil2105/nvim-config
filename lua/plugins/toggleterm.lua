return {
    "akinsho/toggleterm.nvim",
    opts = { direction = "float" },
    config = function(_, opts)
        require("toggleterm").setup(opts)
        local Terminal = require("toggleterm.terminal").Terminal
        local lazygit = Terminal:new { cmd = "lazygit", hidden = true }
        vim.keymap.set("n", "<leader>g", function() lazygit:toggle() end, { desc = "Toggle Lazygit" })
    end,
}
