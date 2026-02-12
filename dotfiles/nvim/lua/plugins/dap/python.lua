local M = {}

function M.setup()
    local dap = require("dap")
    dap.adapters.python = {
        type = "server",
        port = "${port}",
        executable = {
            command = "debugpy-adapter",
            args = { "--port", "${port}" },
        },
    }
    local config = {
        type = "python",
        request = "launch",
        name = "Debug file",
        cwd = vim.fn.getcwd(),
        program = "${file}",
        console = "integratedTerminal",
    }
    dap.configurations.python = { config }
end

return M
