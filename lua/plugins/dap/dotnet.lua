local M = {}

local utils = require("utils")
local dap = require("dap")

local run_file = utils.path_combine(vim.fn.getcwd(), "/run.toml")

function M.enabled() return utils.file_exists(run_file) end

local is_building = false

---@param exec_projects CSProject[]
local function register_build_keymap(exec_projects)
    local build = require("build")

    vim.keymap.set("n", "<leader>bC", function()
        if is_building then return end
        is_building = true
        vim.notify("Building .NET projects...")

        local project_dirs = {}

        for _, project in ipairs(exec_projects) do
            table.insert(project_dirs, project.dir)
        end

        local on_exit = function(idx, exit_code)
            if exit_code ~= 0 then
                local name = exec_projects[idx].name
                vim.notify(name .. " build failed: " .. exit_code)
            end
        end
        local on_completed = function(success, finished)
            if success == finished then
                vim.notify("Build finished.")
                dap.continue()
            end
            is_building = false
        end

        local opts = {
            project_dirs = project_dirs,
            command = "dotnet build",
            on_exit = on_exit,
            on_completed = on_completed,
        }
        build.build_projects(opts)
    end, { desc = "Continue Execution" })
end

function M.setup()
    if not M.enabled() then return end

    local toml = require("toml")
    local csproj = require("plugins.dap.dotnet.csproj")

    local success, run_config = pcall(toml.decodeFromFile, run_file)

    if not success then
        vim.api.nvim_err_writeln(".NET DAP Failure: " .. vim.inspect(run_config))
        return
    end

    dap.adapters.coreclr = {
        type = "executable",
        command = "netcoredbg",
        args = { "--interpreter=vscode" },
    }

    local exec_projects = {}
    local configs = {}

    for app, options in pairs(run_config) do
        local project = csproj.parse(options.project)

        if project == nil then
            vim.api.nvim_err_writeln("Failed to parse .NET project for application " .. app)
        elseif type(project) == "string" then
            vim.api.nvim_err_writeln("Failed to parse .NET project for application " .. app .. ": " .. project)
        elseif project.is_executable then
            local executable =
                utils.path_combine("bin", "Debug", project.target_framework, project.assembly_name .. ".dll")

            local config = {
                type = "coreclr",
                request = "launch",
                name = app,
                cwd = project.dir,
                program = executable,
                args = options.args,
                env = options.env,
            }

            table.insert(exec_projects, project)
            table.insert(configs, config)
        end
    end

    register_build_keymap(exec_projects)
    dap.configurations.cs = configs
end

return M
