local M = {}

local run_file = vim.fn.getcwd() .. "/run.toml"
local prerequisite_file = vim.fn.getcwd() .. "/package.json"

local function enabled() return vim.fn.filereadable(run_file) == 1 and vim.fn.filereadable(prerequisite_file) == 1 end

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

local function configure_node(app, options, configs)
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
        skipFiles = { "<node_internals>/**", "**/node_modules/**" },
    }
    table.insert(configs, config)
end

local function configure_chrome(app, options, configs)
    local config = {
        type = "pwa-chrome",
        request = "launch",
        name = app,
        webRoot = "${workspaceFolder}",
        url = options.main,
        sourceMaps = true,
        protocol = "inspector",
        userDataDir = "${workspaceFolder}/.chromium-user-data",
    }
    table.insert(configs, config)
end

function M.setup()
    if not enabled() then return end

    local dap = require("dap")
    local toml = require("toml")
    local success, run_config = pcall(toml.decodeFromFile, run_file)

    local dap_types = { "pwa-node", "pwa-chrome" }

    for _, dap_type in ipairs(dap_types) do
        dap.adapters[dap_type] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
                command = "node",
                args = {
                    "--inspect",
                    vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
                    "${port}",
                },
            },
        }
    end

    if not success then
        vim.api.nvim_err_writeln("Node.js DAP Failure: " .. vim.inspect(run_config))
        return
    end

    local configs_node = {}
    local configs_chrome = {}

    for app, options in pairs(run_config) do
        if string.match(options.main, "^https?://") then
            configure_chrome(app, options, configs_chrome)
        else
            configure_node(app, options, configs_node)
        end
    end

    register_keymaps(dap, configs_node)
    dap.configurations.typescript = configs_node
    dap.configurations.typescriptreact = configs_chrome
end

return M
