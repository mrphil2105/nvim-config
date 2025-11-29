local utils = require("utils")

local M = {}

---@class BuildProjectOptions
---@field project_name string The name of the project to build.
---@field project_dir string The directory containing the project to build.
---@field command string The command to run to build the specified project.
---@field on_exit? fun(exit_code: integer) A callback function for when the build has completed. The first parameter is the exit code of the build process.

---@class BuildProjectsOptions
---@field project_names string[] The names of the projects to build.
---@field project_dirs string[] The directories containing the projects to build.
---@field command string The command to run to build the specified projects.
---@field on_exit? fun(idx: integer, exit_code: integer) A callback function for when a build has completed. The first parameter is the index of the project that was built, and the second parameter is the exit code of the build process.
---@field on_completed? fun(success: integer, finished: integer) A callback function for when all builds have completed. The first parameter is the number of successful builds, and the second parameter is the number of finished builds.

---@param name string The name of the log buffer to create.
---@return integer buf The created buffer.
---@return integer win The created window or the existing window.
local function create_log_buf(name)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if vim.api.nvim_buf_is_loaded(buf) and utils.endswith(buf_name, name) then
            for _, win in ipairs(vim.api.nvim_list_wins()) do
                local win_buf = vim.api.nvim_win_get_buf(win)
                if win_buf == buf then
                    local new_buf = vim.api.nvim_create_buf(true, true)
                    vim.api.nvim_win_set_buf(win, new_buf)
                    vim.api.nvim_buf_delete(buf, { force = true })
                    vim.api.nvim_buf_set_name(new_buf, name)
                    return new_buf, win
                end
            end
        end
    end
    local current_win = vim.api.nvim_get_current_win()
    vim.api.nvim_command("tabnew")
    local buf = vim.api.nvim_get_current_buf()
    local buf_win = vim.api.nvim_get_current_win()
    vim.api.nvim_buf_set_name(buf, name)
    vim.api.nvim_set_current_win(current_win)
    return buf, buf_win
end

---@param opts BuildProjectOptions The build options for the project.
function M.build_project(opts)
    local buf, win = create_log_buf(opts.project_name)
    local job_id
    local chan = vim.api.nvim_open_term(buf, {
        on_input = function(_, _, _, data) pcall(vim.api.nvim_chan_send, job_id, data) end,
    })
    local on_stdout = function(_, data)
        local count = #data
        for idx, line in ipairs(data) do
            if idx == count then
                pcall(vim.api.nvim_chan_send, chan, line)
            else
                pcall(vim.api.nvim_chan_send, chan, line .. "\n")
            end
        end
    end
    local on_exit = function(_, exit_code)
        pcall(vim.api.nvim_chan_send, chan, "\r\n[Process exited " .. exit_code .. "]")
        if opts.on_exit ~= nil then opts.on_exit(exit_code) end
    end
    local job_opts = {
        cwd = opts.project_dir,
        pty = true,
        height = vim.api.nvim_win_get_height(win),
        width = vim.api.nvim_win_get_width(win),
        on_stdout = on_stdout,
        on_exit = on_exit,
    }
    local cmd, args = opts.command:match("(%S+)%s(.*)")
    job_id = vim.fn.jobstart({ cmd, args }, job_opts)
end

---@param opts BuildProjectsOptions The build options for the projects.
function M.build_projects(opts)
    local success = 0
    local finished = 0
    for idx, project_dir in ipairs(opts.project_dirs) do
        local on_exit = function(exit_code)
            finished = finished + 1
            if exit_code == 0 then success = success + 1 end
            if opts.on_exit ~= nil then opts.on_exit(idx, exit_code) end
            if finished == #opts.project_dirs and opts.on_completed ~= nil then opts.on_completed(success, finished) end
        end
        local build_opts = {
            project_name = opts.project_names[idx],
            project_dir = project_dir,
            command = opts.command,
            on_exit = on_exit,
        }
        M.build_project(build_opts)
    end
end

return M
