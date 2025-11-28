local M = {}
local utils = require("utils")
local run_file = utils.path_combine(vim.fn.getcwd(), "run.toml")

function M.enabled()
    local cmake_lists_file = utils.path_combine(vim.fn.getcwd(), "CMakeLists.txt")
    return utils.file_exists(cmake_lists_file) and utils.file_exists(run_file)
end

local function setup_configs(run_config)
    local dap = require("dap")
    dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
            command = "codelldb",
            args = { "--port", "${port}" },
        },
    }
    local configs = {}
    for app, options in pairs(run_config) do
        local config = {
            type = "codelldb",
            request = "launch",
            name = app,
            cwd = vim.fn.getcwd(),
            sourcePath = utils.path_combine(vim.fn.getcwd(), "src"),
            program = options.executable,
            stopOnEntry = false,
        }
        table.insert(configs, config)
    end
    dap.configurations.c = configs
    dap.configurations.cpp = configs
end

function M.setup()
    if not M.enabled() then
        return
    end
    local toml = require("toml")
    local file_handle, err_msg = io.open(run_file)
    if file_handle == nil then
        vim.api.nvim_echo({ { "C/C++ DAP failure: " .. err_msg } }, false, { err = true })
        return
    end
    local toml_text = file_handle:read("*a")
    file_handle:close()
    local run_config = toml.parse(toml_text)
    setup_configs(run_config)
end

return M
