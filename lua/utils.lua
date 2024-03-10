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

return M
