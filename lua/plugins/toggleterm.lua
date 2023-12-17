return {
    "akinsho/toggleterm.nvim",
    config = function()
        require("toggleterm").setup {
            direction = "float",
            open_mapping = [[<c-\>]],
        }

        local Terminal = require("toggleterm.terminal").Terminal
        local lazygit = Terminal:new { cmd = "lazygit", hidden = true }

        local lazygit_toggle = function() lazygit:toggle() end

        vim.keymap.set("n", "<leader>g", lazygit_toggle, { desc = "Toggle Lazygit" })
    end,
}
