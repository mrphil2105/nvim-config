local M = {}

local run_file = vim.fn.getcwd() .. "/run.toml"
local prerequisite_file = vim.fn.getcwd() .. "/package.json"

local function enabled() return vim.fn.filereadable(run_file) and vim.fn.filereadable(prerequisite_file) end

local function register_keymaps(dap, configs)
    vim.keymap.set("n", "<leader>bA", function()
        for _, config in ipairs(configs) do
            dap.run(config, { new = true })
        end
    end, { desc = "Launch All" })

    vim.keymap.set("n", "<leader>bR", function()
        for _, config in ipairs(configs) do
            dap.restart(config)
        end
    end, { desc = "Restart All" })
end

function M.setup()
    if enabled() == 0 then return end

    local dap = require("dap")
    local toml = require("toml")
    local success, run_config = pcall(toml.decodeFromFile, run_file)

    dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
            command = "node",
            args = {
                vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
                "${port}",
            },
        },
    }

    if success then
        local configs = {}

        for app, options in pairs(run_config) do
            local js_file = vim.fn.getcwd() .. "/" .. options.main
            local config = {
                type = "pwa-node",
                request = "launch",
                name = app,
                cwd = "${workspaceFolder}",
                program = js_file,
                args = options.args,
                env = options.env,
                sourceMaps = true,
                protocol = "inspector",
                console = "integratedTerminal",
                skipFiles = { "<node_internals>/**", "node_modules/**" },
            }
            table.insert(configs, config)
        end

        register_keymaps(dap, configs)
        dap.configurations.typescript = configs
    else
        vim.api.nvim_err_writeln("Node.js DAP Failure: " .. vim.inspect(run_config))
    end
end

return M
