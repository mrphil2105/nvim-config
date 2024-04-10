return {
    "mfussenegger/nvim-dap",
    dependencies = {
        { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
        "nvim-telescope/telescope-dap.nvim",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        local configs = { "dotnet", "rust", "nodejs" }

        for _, config in ipairs(configs) do
            local dap_config = require("plugins.dap." .. config)
            if dap_config.enabled() then
                dap_config.setup()

                if dap_config.setup_dapui ~= nil then
                    dap_config.setup_dapui()
                else
                    local dapui_config = require("plugins.dapui.config")
                    dapui.setup(dapui_config)
                end

                break
            end
        end

        vim.keymap.set("n", "<leader>bt", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
        vim.keymap.set("n", "<leader>be", dap.set_exception_breakpoints, { desc = "Exception Breakpoints" })
        vim.keymap.set("n", "<leader>bc", dap.continue, { desc = "Continue Execution" })
        vim.keymap.set("n", "<leader>bs", dap.step_over, { desc = "Step Over" })
        vim.keymap.set("n", "<leader>bi", dap.step_into, { desc = "Step Into" })
        vim.keymap.set("n", "<leader>bo", dap.step_out, { desc = "Step Out" })
        vim.keymap.set("n", "<leader>br", function() dapui.float_element("repl") end, { desc = "Open Repl" })
        vim.keymap.set("n", "<leader>bT", dapui.toggle, { desc = "Toggle DAP UI" })
    end,
}
