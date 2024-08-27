local api = vim.api

local M = {}

---@class OpenWinOptions
---@field title string The title to display.
---@field buf buffer The buffer to open a window for.
---@field width integer The width of the window.
---@field height integer The height of the window.
---@field row integer The row position of the window.
---@field col integer The column position of the window.

---@param opts OpenWinOptions The options for the window to open.
function M.open_win(opts)
    local win = api.nvim_open_win(opts.buf, true, {
        relative = "editor",
        width = opts.width,
        height = opts.height,
        row = opts.row,
        col = opts.col,
        style = "minimal",
        border = "rounded",
        title = opts.title,
        title_pos = "center",
    })
    return win
end

---@param win window The window to scroll to the bottom.
function M.scroll_bottom(win)
    local buf = api.nvim_win_get_buf(win)
    local line_count = api.nvim_buf_line_count(buf)
    api.nvim_win_set_cursor(win, { line_count, 0 })
end

return M
