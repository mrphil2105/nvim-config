local M = {}

local run_file = vim.fn.getcwd() .. "/run.toml"
local prerequisite_file = vim.fn.getcwd() .. "/package.json"

function M.enabled()
    local utils = require("utils")
    return utils.file_exists(run_file) and utils.file_exists(prerequisite_file)
end

local function register_keymaps(dap, configs)
    local utils = require("utils")

    vim.keymap.set("n", "<leader>bA", function()
        for _, config in ipairs(configs) do
            dap.run(config, { new = true })
        end
    end, { desc = "Launch All" })

    vim.keymap.set("n", "<leader>bS", function()
        local sessions = dap.sessions()

        for _, session in pairs(sessions) do
            dap.set_session(session)
            dap.disconnect()
            dap.close()
        end

        for _, config in ipairs(configs) do
            for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
                local buffer_name = vim.api.nvim_buf_get_name(buffer)

                if vim.api.nvim_buf_is_loaded(buffer) and utils.endswith(buffer_name, config.name) then
                    vim.api.nvim_buf_delete(buffer, { force = true })
                end
            end
        end
    end, { desc = "Stop All" })
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
    if not M.enabled() then return end

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

function M.setup_dapui()
    local dapui_config = {
        controls = {
            element = "repl",
            enabled = true,
            icons = {
                disconnect = "",
                pause = "",
                play = "",
                run_last = "",
                step_back = "",
                step_into = "",
                step_out = "",
                step_over = "",
                terminate = "",
            },
        },
        element_mappings = {},
        expand_lines = true,
        floating = {
            border = "single",
            mappings = {
                close = { "q", "<Esc>" },
            },
        },
        force_buffers = true,
        icons = {
            collapsed = "",
            current_frame = "",
            expanded = "",
        },
        layouts = {
            {
                elements = {
                    {
                        id = "scopes",
                        size = 0.66,
                    },
                    {
                        id = "breakpoints",
                        size = 0.33,
                    },
                },
                position = "left",
                size = 40,
            },
        },
        mappings = {
            edit = "e",
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            repl = "r",
            toggle = "t",
        },
        render = {
            indent = 1,
            max_value_lines = 100,
        },
    }
    require("dapui").setup(dapui_config)
    require("dap").defaults.fallback.terminal_win_cmd = "tabnew"
end
return M
