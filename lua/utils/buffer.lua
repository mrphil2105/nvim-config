local api = vim.api

local M = {}

---@param buf integer The buffer to check.
function M.is_buf_empty(buf)
    local line_count = api.nvim_buf_line_count(buf)
    if line_count > 1 then return false end
    local lines = api.nvim_buf_get_lines(buf, 0, 1, false)
    return lines[1] == ""
end

---@param buf integer The buffer to append to.
---@param line string The line to append.
---@param overwrite_modifiable? boolean Whether to set modifiable to true before appending and restore it again after.
function M.buf_append_line(buf, line, overwrite_modifiable)
    local old_modifiable = nil
    if overwrite_modifiable then
        old_modifiable = api.nvim_get_option_value("modifiable", { buf = buf })
        api.nvim_set_option_value("modifiable", true, { buf = buf })
    end

    local is_empty = M.is_buf_empty(buf)
    if is_empty then
        api.nvim_buf_set_lines(buf, 0, -1, false, { line })
    else
        local line_count = api.nvim_buf_line_count(buf)
        api.nvim_buf_set_lines(buf, line_count, line_count, false, { line })
    end

    if overwrite_modifiable then api.nvim_set_option_value("modifiable", old_modifiable, { buf = buf }) end
end

return M
