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

---Opens a select menu to pick one of the specified items. Must be run inside a coroutine if no callback is specified.
---@param items any[] The items to select from.
---@param prompt string The caption to display for the prompt.
---@param label_item fun(item: any): string The function to retrieve labels for items.
---@return any item The selected item or nil if none, only if no callback is specified.
function M.select_one(items, prompt, label_item, on_choice)
    local co
    if not on_choice then
        co = coroutine.running()
        if not co then error("A function for on_choice must be provided when not running in a coroutine.") end
        on_choice = function(item) coroutine.resume(co, item) end
    end
    on_choice = vim.schedule_wrap(on_choice)
    vim.ui.select(items, { prompt = prompt, format_item = label_item }, on_choice)
    if co then return coroutine.yield() end
end

---Opens a select menu to pick one of the specified items, or returns the only item if the list has length of one. Must
---be run inside a coroutine if no callback is specified.
---@param items any[] The items to select from.
---@param prompt string The caption to display for the prompt.
---@param label_item fun(item: any): string The function to retrieve labels for items.
---@return any item The selected item or nil if none, only if no callback is specified.
function M.select_if_many(items, prompt, label_item, on_choice)
    if #items == 0 then return nil end
    if #items == 1 then
        if not on_choice then return items[1] end
        on_choice(items[1])
        return
    end
    return M.select_one(items, prompt, label_item, on_choice)
end

return M
