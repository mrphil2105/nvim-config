local M = {}

function M.endswith(str, suf) return string.sub(str, -#suf) == suf end

return M
