local M = {}

function M.table_count(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

function M.table_map(tbl, f)
    local res = {}
    for k, v in pairs(tbl) do
        res[k] = f(v)
    end
    return res
end

function M.list_map(tbl, f)
    local res = {}
    for i, v in ipairs(tbl) do
        res[i] = f(v)
    end
    return res
end

function M.table_filter(tbl, f)
    local res = {}
    for k, v in pairs(tbl) do
        if f(v, k) then res[k] = v end
    end
    return res
end

function M.list_filter(lst, f)
    local res = {}
    local idx = 1
    for i, v in ipairs(lst) do
        if f(v, i) then
            res[idx] = v
            idx = idx + 1
        end
    end
    return res
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
    local count = M.table_count(parts)
    local path = ""
    for i = 1, count do
        local part = parts[i]
        if i ~= 1 and part:sub(1, 1) == "/" then part = part:sub(2) end

        path = path .. part
        if i ~= count and path:sub(-1) ~= "/" then path = path .. "/" end
    end
    return path
end

return M
