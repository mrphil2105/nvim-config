local M = {}

local cargo_file = vim.fn.getcwd() .. "/Cargo.toml"

local function enabled() return vim.fn.filereadable(cargo_file) == 1 end

function M.setup()
    if not enabled() then return end

    local dap = require("dap")
    local toml = require("toml")
    local success, cargo_manifest = pcall(toml.decodeFromFile, cargo_file)

    if not success then
        vim.api.nvim_err_writeln("Rust DAP Failure: " .. vim.inspect(cargo_manifest))
        return
    end

    dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
            command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/codelldb",
            args = { "--port", "${port}" },
        },
    }

    dap.configurations.rust = {
        {
            type = "codelldb",
            request = "launch",
            name = "Debug application",
            cwd = "${workspaceFolder}",
            program = function()
                local output = vim.fn.system("cargo build")
                if vim.v.shell_error ~= 0 then vim.notify("Cargo build failed: " .. output) end
                return vim.fn.getcwd() .. "/target/debug/" .. cargo_manifest.package.name
            end,
            stopOnEntry = false,
        },
    }
end

return M
