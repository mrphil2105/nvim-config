local M = {}

function M.table_length(tab)
    local count = 0
    for _ in pairs(tab) do
        count = count + 1
    end
    return count
end

function M.endswith(str, suf) return string.sub(str, -#suf) == suf end

function M.file_exists(path) return vim.fn.filereadable(path) == 1 end

---@param filename string The file name or path to check.
---@param extension string The file extension to check for.
function M.has_file_extension(filename, extension)
    filename = vim.fs.basename(filename)
    return filename:match("^.+(%..+)$") == extension
end

---Combines a list of path segments to a full path.
---@param ... string A list of path segments to combine.
---@return string
function M.path_combine(...)
    local parts = { ... }
    local len = M.table_length(parts)
    local path = ""
    for i = 1, len do
        local part = parts[i]
        if i ~= 1 and part:sub(1, 1) == "/" then part = part:sub(2) end

        path = path .. part
        if i ~= len and path:sub(-1) ~= "/" then path = path .. "/" end
    end
    return path
end

function M.is_buf_empty(buf)
    local line_count = vim.api.nvim_buf_line_count(buf)
    if line_count > 1 then return false end
    local lines = vim.api.nvim_buf_get_lines(buf, 0, 1, false)
    return lines[1] == ""
end

return M
