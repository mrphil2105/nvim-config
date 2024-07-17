local M = {}

function M.table_length(tab)
    local count = 0
    for _ in pairs(tab) do
        count = count + 1
    end
    return count
end

function M.has_value(tab, val)
    for _, value in pairs(tab) do
        if value == val then return true end
    end

    return false
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

function M.get_random_filename(length)
    if length == nil then length = 8 end

    local timestamp = os.time()
    local random_string = ""

    for _ = 1, length do
        local rand = math.random(1, 62)
        local char
        if rand <= 10 then
            char = tostring(rand - 1)
        elseif rand <= 36 then
            char = string.char(rand + 54)
        else
            char = string.char(rand + 60)
        end
        random_string = random_string .. char
    end

    local filename = "random_" .. timestamp .. "_" .. random_string
    return filename
end

function M.remove_bom()
    local first_line = vim.fn.getline(1)

    if string.sub(first_line, 1, 3) == "\239\187\191" then
        vim.api.nvim_buf_set_lines(0, 0, 1, false, { string.sub(first_line, 4) })
    end
end

return M
