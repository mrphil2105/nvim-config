local M = {}

local function get_project_files()
    local utils = require("utils")

    local cwd = vim.fn.getcwd()
    local project_files = {}

    local cwd_name = vim.fs.dirname(cwd)
    local project_file = cwd .. "/" .. cwd_name .. ".csproj"

    if utils.file_exists(project_file) then table.insert(project_files, project_file) end

    for path_name, type in vim.fs.dir(cwd) do
        --vim.notify("Path Name: " .. path_name)
        if type == "directory" then
            project_file = cwd .. "/" .. path_name .. "/" .. path_name .. ".csproj"
            --vim.notify("Project File: " .. project_file)
            if utils.file_exists(project_file) then table.insert(project_files, project_file) end
        end
    end

    return project_files
end

function M.enabled()
    local utils = require("utils")
    local project_files = get_project_files()
    return utils.table_length(project_files) > 0
end

local is_building = false

local function register_build_keymap(project_files)
    local dap = require("dap")
    local utils = require("utils")

    -- Schedule a callback because '<leader>bc' is configured in dap.lua after the current function completes.
    vim.schedule(function()
        vim.keymap.set("n", "<leader>bc", function()
            if is_building then return end
            is_building = true
            vim.notify("Building .NET projects...")

            local success_count = 0
            local finished_count = 0
            local project_count = utils.table_length(project_files)

            for _, project_file in ipairs(project_files) do
                local working_dir = vim.fs.dirname(project_file)
                local on_exit = function(_, exit_code)
                    if exit_code == 0 then
                        success_count = success_count + 1

                        if success_count == project_count then
                            vim.notify("Build finished.")
                            dap.continue()
                        end
                    else
                        vim.notify("Dotnet build failed with code: " .. exit_code)
                    end

                    finished_count = finished_count + 1
                    if finished_count == project_count then is_building = false end
                end

                local opts = {
                    cwd = working_dir,
                    on_exit = on_exit,
                }
                vim.fn.jobstart({ "dotnet", "build" }, opts)
            end
        end, { desc = "Continue Execution" })
    end)
end

function M.setup()
    local project_files = get_project_files()
    if next(project_files) == nil then return end

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
