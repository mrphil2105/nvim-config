local M = {}

local function get_project_files()
    local utils = require("utils")
    local project_files = {}
    local cwd = vim.fn.getcwd()
    local cwd_name = vim.fs.basename(cwd)
    local project_file = utils.path_combine(cwd, cwd_name .. ".csproj")

    if utils.file_exists(project_file) then table.insert(project_files, project_file) end

    for path_name, type in vim.fs.dir(cwd) do
        if type == "directory" then
            project_file = utils.path_combine(cwd, path_name, path_name .. ".csproj")
            if utils.file_exists(project_file) then table.insert(project_files, project_file) end
        end
    end

    return project_files
end

function M.enabled()
    local project_files = get_project_files()
    return #project_files > 0
end

local is_building = false

local function register_build_keymap(project_files)
    local dap = require("dap")
    local build = require("build")
    local csproj = require("plugins.dap.dotnet.csproj")

    vim.keymap.set("n", "<leader>bC", function()
        if is_building then return end
        is_building = true
        vim.notify("Building .NET projects...")

        local project_dirs = {}

        for _, project_file in ipairs(project_files) do
            local project = csproj.parse(project_file)
            if project ~= nil and project.is_executable then
                local project_dir = vim.fs.dirname(project_file)
                table.insert(project_dirs, project_dir)
            end
        end

        local on_exit = function(idx, exit_code)
            local name = vim.fs.basename(project_dirs[idx])
            if exit_code ~= 0 then vim.notify(name .. " build failed: " .. exit_code) end
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

    local project_files = get_project_files()
    local utils = require("utils")
    local dap = require("dap")
    local csproj = require("plugins.dap.dotnet.csproj")

    dap.adapters.coreclr = {
        type = "executable",
        command = "netcoredbg",
        args = { "--interpreter=vscode" },
    }

    local configs = {}

    for _, project_file in ipairs(project_files) do
        local project = csproj.parse(project_file)
        local project_name = vim.fs.basename(project_file):sub(1, -8)

        if project == nil then
            vim.api.nvim_err_writeln("Failed to parse .NET project " .. project_name)
        elseif type(project) == "string" then
            vim.api.nvim_err_writeln("Failed to parse .NET project " .. project_name .. ": " .. project)
        elseif project.is_executable then
            local working_dir = vim.fs.dirname(project_file)
            local executable = utils.path_combine(
                working_dir,
                "bin",
                "Debug",
                project.target_framework,
                project.assembly_name .. ".dll"
            )

            local config = {
                type = "coreclr",
                request = "launch",
                name = project_name,
                cwd = working_dir,
                program = executable,
            }
            table.insert(configs, config)
        end
    end

    register_build_keymap(project_files)
    dap.configurations.cs = configs
end

return M
