local utils = require("utils")
local dap = require("dap")
local vscode = require("dap.ext.vscode")

local M = {}

local launch_file = vim.fn.getcwd() .. "/.vscode/launch.json"
local prerequisite_file = vim.fn.getcwd() .. "/package.json"

function M.enabled()
    return utils.file_exists(launch_file) and utils.file_exists(prerequisite_file)
end

local is_running = false

local function register_keymaps()
    vim.keymap.set("n", "<leader>bA", function()
        if is_running then
            return
        end
        for _, config in ipairs(dap.configurations["typescript"]) do
            dap.run(config, { new = true })
        end
        is_running = true
    end, { desc = "Launch All" })
    vim.keymap.set("n", "<leader>bF", function()
        for _, config in ipairs(dap.configurations["typescriptreact"]) do
            dap.run(config, { new = true })
        end
    end, { desc = "Launch Frontend" })
    vim.keymap.set("n", "<leader>bS", function()
        if not is_running then
            return
        end
        local sessions = dap.sessions()

        for _, session in pairs(sessions) do
            if session.config.type == "pwa-node" then
                dap.set_session(session)
                dap.terminate()
            end
        end

        for _, config in ipairs(dap.configurations["typescript"]) do
            for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
                local buffer_name = vim.api.nvim_buf_get_name(buffer)

                if vim.api.nvim_buf_is_loaded(buffer) and utils.endswith(buffer_name, config.name) then
                    vim.api.nvim_buf_delete(buffer, { force = true })
                end
            end
        end
        is_running = false
    end, { desc = "Stop All" })
end

function M.setup()
    if not M.enabled() then
        return
    end
    local type_to_filetypes = { node = { "typescript" }, chrome = { "typescriptreact" } }
    local configs = vscode.getconfigs()
    for dap_type, _ in pairs(type_to_filetypes) do
        dap.adapters["pwa-" .. dap_type] = {
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
    for _, config in ipairs(configs) do
        local filetypes = type_to_filetypes[config.type]
        for _, filetype in ipairs(filetypes) do
            local dap_configs = dap.configurations[filetype] or {}
            for i, dap_config in pairs(dap_configs) do
                if dap_config.name == config.name then
                    table.remove(dap_configs, i)
                end
            end
            if config.type == "chrome" then
                ---@diagnostic disable-next-line: inject-field
                config.userDataDir = "${workspaceFolder}/.chromium-user-data"
                ---@diagnostic disable-next-line: inject-field
                config.skipFiles = {
                    "<node_internals>/**",
                    "node_modules/**",
                    "**/node_modules/**",
                    "webpack:///node_modules/**",
                    "webpack:///webpack/*",
                    "esbuild://**",
                }
            end
            if config.type == "node" then
                ---@diagnostic disable-next-line: inject-field
                config.console = "integratedTerminal"
                ---@diagnostic disable-next-line: inject-field
                config.skipFiles = {
                    "<node_internals>/**",
                    "node_modules/**",
                    "**/node_modules/**",
                    "webpack:///node_modules/**",
                    "webpack:///webpack/*",
                    "esbuild://**",
                }
            end
            ---@diagnostic disable-next-line: inject-field
            config.protocol = "inspector"
            config.type = "pwa-" .. config.type
            -- config.resolveSourceMapLocations = { "!**/node_modules/**", "**" }
            -- config.sourceMaps = false
            table.insert(dap_configs, config)
            dap.configurations[filetype] = dap_configs
        end
    end
    register_keymaps()
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
