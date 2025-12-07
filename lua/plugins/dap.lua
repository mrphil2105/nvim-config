local function toggle_dap_view() vim.api.nvim_command("DapViewToggle") end

local function set_dap_session()
    coroutine.wrap(function()
        local dap = require("dap")
        local session = require("utils.dap").select_session()
        if session == nil then
            vim.notify("No session selected.")
            return
        end
        vim.notify("Setting session to: " .. session.config.name)
        dap.set_session(session)
    end)()
end

local function restart_dap_session()
    coroutine.wrap(function()
        local dap = require("dap")
        local session = require("utils.dap").select_session()
        if session == nil then
            vim.notify("No session selected.")
            return
        end
        vim.notify("Restarting session: " .. session.config.name)
        dap.set_session(session)
        dap.terminate()
        vim.defer_fn(function() dap.run(session.config, { new = true }) end, 500)
    end)()
end

local function terminate_dap_session()
    coroutine.wrap(function()
        local dap = require("dap")
        local session = require("utils.dap").select_session()
        if session == nil then
            vim.notify("No session selected.")
            return
        end
        vim.notify("Terminating session: " .. session.config.name)
        dap.set_session(session)
        dap.terminate()
    end)()
end

return {
    "mfussenegger/nvim-dap",
    dependencies = { "igorlfs/nvim-dap-view" },
    config = function()
        local configs = { "cpp", "dotnet", "rust", "nodejs" }
        for _, config in ipairs(configs) do
            local dap_config = require("plugins.dap." .. config)
            if dap_config.enabled() then
                dap_config.setup()
                if dap_config.setup_dapview ~= nil then
                    dap_config.setup_dapview()
                else
                    require("dap-view").setup()
                end
                break
            end
        end
    end,
    keys = {
        { "<leader>bt", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
        { "<leader>be", function() require("dap").set_exception_breakpoints() end, desc = "Exception Breakpoints" },
        { "<leader>bc", function() require("dap").continue() end, desc = "Continue Execution" },
        { "<leader>bs", function() require("dap").step_over() end, desc = "Step Over" },
        { "<leader>bi", function() require("dap").step_into() end, desc = "Step Into" },
        { "<leader>bo", function() require("dap").step_out() end, desc = "Step Out" },
        { "<leader>br", function() require("plugins.dap.ui.repl").show_popup() end, desc = "Open Repl" },
        { "<leader>bT", toggle_dap_view, desc = "Toggle DAP View" },
        { "<leader>ba", set_dap_session, desc = "Set Active Session" },
        { "<leader>bR", restart_dap_session, desc = "Restart Session" },
        { "<leader>bk", terminate_dap_session, desc = "Terminate Session" },
    },
}
