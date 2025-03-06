local api = vim.api
local utils = require("utils")
local ui = require("ui")
local dap = require("dap")
local dap_utils = require("dap.utils")
local dap_ui = require("dap.ui")
local dap_entity = require("dap.entity")

local M = {}

local is_initialized = false
local output_buf = 0
local input_buf = 0

local history = {
    entries = {},
    idx = 1,
    max_size = 100,
}

---@param input string The input to append to the history.
local function insert_history(input)
    if #history.entries == history.max_size then table.remove(history.entries, 1) end
    table.insert(history.entries, input)
    history.idx = #history.entries + 1
end

---@param delta integer The amount to move the history index by.
---@param buf integer The buffer to update with the selected history entry.
local function select_history(delta, buf)
    history.idx = history.idx + delta
    if history.idx < 1 then
        history.idx = #history.entries
    elseif history.idx > #history.entries then
        history.idx = 1
    end
    local input = history.entries[history.idx]
    if input then
        local line_number = vim.fn.line("$")
        api.nvim_buf_set_lines(buf, line_number - 1, line_number, true, { "> " .. input })
        vim.fn.setcursorcharpos { line_number, vim.fn.col("$") }
    end
end

local function init_repl()
    output_buf = api.nvim_create_buf(false, true)
    input_buf = api.nvim_create_buf(false, true)
    api.nvim_set_option_value("buflisted", false, { buf = output_buf })
    api.nvim_set_option_value("modifiable", false, { buf = output_buf })
    api.nvim_set_option_value("buflisted", false, { buf = input_buf })
    api.nvim_set_option_value("buftype", "prompt", { buf = input_buf })
    api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        buffer = input_buf,
        callback = function() api.nvim_set_option_value("modified", false, { buf = input_buf }) end,
    })
    is_initialized = true
end

---@class ReplPopup
---@field output_win integer The window of the output buffer.
---@field input_win integer The window of the input buffer.

---@class ReplPopupOpts Options for opening a REPL popup.
---@field on_prompt fun(input: string, output_win: integer, input_win: integer) The function to call when prompted.
---@field on_close? fun() The function to call when the popup is closed.

---@param opts ReplPopupOpts The options to use when opening the popup.
---@return ReplPopup popup The opened popup windows.
local function open_wins(opts)
    opts = opts or {}
    local width = api.nvim_get_option_value("columns", {})
    local height = api.nvim_get_option_value("lines", {})
    local win_width = math.floor(width * 0.6)
    local win_height = math.floor(height * 0.6)
    local output_opts = {
        title = "REPL Output",
        buf = output_buf,
        width = win_width,
        height = win_height,
        row = math.floor((height - win_height) / 2) - 2,
        col = math.floor((width - win_width) / 2),
    }
    local input_opts = {
        title = "REPL Input",
        buf = input_buf,
        width = win_width,
        height = 1,
        row = output_opts.row + output_opts.height + 2,
        col = output_opts.col,
    }
    local output_win = ui.open_win(output_opts)
    local input_win = ui.open_win(input_opts)
    vim.fn.prompt_setprompt(input_buf, "> ")
    vim.fn.prompt_setcallback(input_buf, function(input) opts.on_prompt(input, output_win, input_win) end)
    vim.cmd("startinsert!")
    local function close_popup()
        api.nvim_win_close(output_win, true)
        api.nvim_win_close(input_win, true)
        if opts.on_close then opts.on_close() end
    end
    vim.keymap.set("n", "<Esc>", close_popup, { buffer = output_buf })
    vim.keymap.set("n", "<Esc>", close_popup, { buffer = input_buf })
    vim.keymap.set("i", "<C-p>", function() select_history(-1, input_buf) end, { buffer = input_buf })
    vim.keymap.set("i", "<C-n>", function() select_history(1, input_buf) end, { buffer = input_buf })
    ui.scroll_bottom(output_win)
    return {
        output_win = output_win,
        input_win = input_win,
    }
end

---@param err dap.ErrorResponse The error to print to the output buffer.
---@param auto_scroll boolean Whether to scroll to the bottom of the output buffer.
---@param output_win integer The window of the output buffer.
local function print_error(err, auto_scroll, output_win)
    local message = dap_utils.fmt_error(err)
    if message then
        utils.buf_append_line(output_buf, message, true)
    else
        utils.buf_append_line(output_buf, "An error has occurred.", true)
        vim.print("Error: " .. vim.inspect(err))
    end
    if auto_scroll then ui.scroll_bottom(output_win) end
end

function M.show_popup()
    if not is_initialized then init_repl() end
    local on_prompt = function(input, output_win)
        local session = dap.session()
        if session == nil then
            utils.buf_append_line(output_buf, "No active debug session.", true)
            return
        end
        session:evaluate(input, function(err, resp)
            local line_count = api.nvim_buf_line_count(output_buf)
            local cur_line = api.nvim_win_get_cursor(output_win)[1]
            local auto_scroll = cur_line == line_count
            local is_empty = utils.is_buf_empty(output_buf)
            if err then
                print_error(err, auto_scroll, output_win)
                return
            end
            local layer = dap_ui.layer(output_buf)
            local spec = dap_entity.variable.tree_spec
            local tree = dap_ui.new_tree(spec)
            tree.render(layer, resp, function()
                if auto_scroll then ui.scroll_bottom(output_win) end
            end, is_empty and 0 or line_count, -1)
        end)
        insert_history(input)
    end
    open_wins { on_prompt = on_prompt }
end

return M
