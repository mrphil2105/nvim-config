return {
    "mfussenegger/nvim-dap",
    dependencies = {
        { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
        "nvim-telescope/telescope-dap.nvim",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        local dap_utils = require("plugins.dap.utils")
        local repl = require("plugins.dap.ui.repl")

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
        vim.keymap.set("n", "<leader>br", repl.show_popup, { desc = "Open Repl" })
        vim.keymap.set("n", "<leader>bT", dapui.toggle, { desc = "Toggle DAP UI" })

        vim.keymap.set("n", "<leader>ba", function()
            coroutine.wrap(function()
                local session = dap_utils.select_session()
                if session == nil then
                    vim.notify("No session selected.")
                    return
                end
                vim.notify("Setting session to: " .. session.config.name)
                dap.set_session(session)
            end)()
        end, { desc = "Set Active Session" })

        vim.keymap.set("n", "<leader>bR", function()
            coroutine.wrap(function()
                local session = dap_utils.select_session()
                if session == nil then
                    vim.notify("No session selected.")
                    return
                end
                vim.notify("Restarting session: " .. session.config.name)
                dap.set_session(session)
                dap.terminate()
                vim.defer_fn(function() dap.run(session.config, { new = true }) end, 500)
            end)()
        end, { desc = "Restart Session" })
    end,
}
