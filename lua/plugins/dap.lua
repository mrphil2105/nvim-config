return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "nvim-telescope/telescope-dap.nvim",
    },
    config = function()
        local dap = require("dap")
        dap.defaults.fallback.terminal_win_cmd = "tabnew"

        vim.keymap.set("n", "<leader>bt", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
        vim.keymap.set("n", "<leader>be", dap.set_exception_breakpoints, { desc = "Exception Breakpoints" })
        vim.keymap.set("n", "<leader>bc", dap.continue, { desc = "Continue Execution" })
        vim.keymap.set("n", "<leader>bs", dap.step_over, { desc = "Step Over" })
        vim.keymap.set("n", "<leader>bi", dap.step_into, { desc = "Step Into" })
        vim.keymap.set("n", "<leader>bo", dap.step_out, { desc = "Step Out" })
        vim.keymap.set("n", "<leader>br", dap.repl.open, { desc = "Open Repl" })
    end,
}
