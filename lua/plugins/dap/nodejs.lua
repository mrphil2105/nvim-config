local utils = require("utils")
local dap = require("dap")
local vscode = require("dap.ext.vscode")

local M = {}

local launch_file = vim.fn.getcwd() .. "/.vscode/launch.json"
local prerequisite_file = vim.fn.getcwd() .. "/package.json"
local js_dap_env_var = "JS_DAP_SERVER"

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
    local js_dap_path = os.getenv(js_dap_env_var)
    if js_dap_path == nil then
        local err_msg = "Environment variable " .. js_dap_env_var .. " must be set."
        vim.schedule(function()
            vim.api.nvim_echo({ { err_msg } }, false, { err = true })
        end)
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
                    js_dap_path,
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
                config.skipFiles = { "<node_internals>/**", "node_modules/**", "**/node_modules/**" }
            end
            if config.type == "node" then
                ---@diagnostic disable-next-line: inject-field
                config.console = "integratedTerminal"
                ---@diagnostic disable-next-line: inject-field
                config.skipFiles = { "<node_internals>/**", "node_modules/**", "**/node_modules/**" }
            end
            ---@diagnostic disable-next-line: inject-field
            config.protocol = "inspector"
            config.type = "pwa-" .. config.type
            table.insert(dap_configs, config)
            dap.configurations[filetype] = dap_configs
        end
    end
    register_keymaps()
end

function M.setup_dapview()
    ---@type dapview.Config
    local dapview_config = {
        windows = {
            terminal = {
                hide = { "pwa-node", "pwa-chrome" },
            },
        },
        winbar = {
            sections = { "watches", "scopes", "exceptions", "breakpoints", "threads" },
        },
    }
    require("dap-view").setup(dapview_config)
    require("dap").defaults.fallback.terminal_win_cmd = "tabnew"
end

return M
