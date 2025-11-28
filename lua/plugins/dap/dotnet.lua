local M = {}
local utils = require("utils")
local dap = require("dap")
local run_file = utils.path_combine(vim.fn.getcwd(), "/run.toml")
local is_building = false

function M.enabled()
    local cwd = vim.fn.getcwd()
    local has_solution = false
    for path_name, type in vim.fs.dir(cwd) do
        if type == "file" and path_name:match("%.sln$") then
            has_solution = true
        end
    end
    return has_solution and utils.file_exists(run_file)
end

---@param exec_projects CSProject[]
local function register_build_keymap(exec_projects)
    local build_utils = require("utils.build")
    vim.keymap.set("n", "<leader>bC", function()
        if is_building then
            return
        end
        is_building = true
        vim.notify("Building .NET projects...")
        local project_names = {}
        local project_dirs = {}
        for _, project in ipairs(exec_projects) do
            table.insert(project_names, project.name)
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
            project_names = project_names,
            project_dirs = project_dirs,
            command = "dotnet build",
            on_exit = on_exit,
            on_completed = on_completed,
        }
        build_utils.build_projects(opts)
    end, { desc = "Continue Execution" })
end

function M.setup()
    if not M.enabled() then
        return
    end
    local toml = require("toml")
    local csproj = require("plugins.dap.dotnet.csproj")
    local file_handle, err_msg = io.open(run_file)
    if file_handle == nil then
        vim.api.nvim_echo({ { ".NET DAP failure: " .. err_msg } }, false, { err = true })
        return
    end
    local toml_text = file_handle:read("*a")
    file_handle:close()
    local run_config = toml.parse(toml_text)
    local exec_projects = {}
    local configs = {}
    for app, options in pairs(run_config) do
        local project = csproj.parse(options.project)
        if project == nil then
            vim.api.nvim_echo({ { "Failed to parse .NET project for application " .. app } }, false, { err = true })
        elseif type(project) == "string" then
            vim.api.nvim_echo(
                { { "Failed to parse .NET project for application " .. app .. ": " .. project } },
                false,
                { err = true }
            )
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
    dap.adapters.coreclr = {
        type = "executable",
        command = "netcoredbg",
        args = { "--interpreter=vscode" },
    }
    dap.configurations.cs = configs
end

return M
