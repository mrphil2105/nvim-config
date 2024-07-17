local M = {}

---@class ReplPopup
---@field input_buf buffer
---@field output_buf buffer
---@field input_win window
---@field output_win window

---@class ReplPopupOpts
---@field on_prompt function
---@field on_close? function

---@param opts ReplPopupOpts
---@return ReplPopup popup
function M.show_repl_popup(opts)
    opts = opts or {}

    local width = vim.api.nvim_get_option_value("columns", {})
    local height = vim.api.nvim_get_option_value("lines", {})

    local output_width = math.floor(width * 0.6)
    local output_height = math.floor(height * 0.6)
    local output_row = math.floor((height - output_height) / 2) - 2
    local output_col = math.floor((width - output_width) / 2)

    local input_width = output_width
    local input_height = 1
    local input_row = output_row + output_height + input_height + 1
    local input_col = output_col

    -- Create the results window
    local output_buf = vim.api.nvim_create_buf(false, true)
    local output_win = vim.api.nvim_open_win(output_buf, true, {
        relative = "editor",
        width = output_width,
        height = output_height,
        row = output_row,
        col = output_col,
        style = "minimal",
        border = "rounded",
        title = "REPL Output",
        title_pos = "center",
    })

    -- Create the prompt window
    local input_buf = vim.api.nvim_create_buf(false, true)
    local input_win = vim.api.nvim_open_win(input_buf, true, {
        relative = "editor",
        width = input_width,
        height = input_height,
        row = input_row,
        col = input_col,
        style = "minimal",
        border = "rounded",
        title = "REPL Input",
        title_pos = "center",
    })

    vim.api.nvim_set_option_value("modifiable", false, { buf = output_buf })
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = output_buf })

    vim.api.nvim_set_option_value("buftype", "prompt", { buf = input_buf })
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = input_buf })
    vim.fn.prompt_setprompt(input_buf, "> ")
    vim.fn.prompt_setcallback(input_buf, function(input) opts.on_prompt(input, output_buf) end)
    vim.cmd("startinsert!")

    local function close_popup()
        vim.api.nvim_win_close(output_win, true)
        vim.api.nvim_win_close(input_win, true)
        if opts.on_close then opts.on_close() end
    end

    vim.keymap.set("n", "<Esc>", close_popup, { buffer = input_buf })
    vim.keymap.set("n", "<Esc>", close_popup, { buffer = output_buf })

    return {
        input_buf = input_buf,
        output_buf = output_buf,
        input_win = input_win,
        output_win = output_win,
    }
end

vim.api.nvim_create_user_command("FooBar", function()
    local dap = require("dap")
    local session = dap.session()
    local ui = require("dap.ui")
    M.show_repl_popup {
        on_prompt = function(input, output_buf)
            session:evaluate(input, function(err, resp)
                local utils = require("dap.utils")
                if err then
                    local message = utils.fmt_error(err)
                    if message then
                        local line_count = vim.api.nvim_buf_line_count(output_buf)
                        vim.api.nvim_set_option_value("modifiable", true, { buf = output_buf })
                        vim.api.nvim_buf_set_lines(output_buf, line_count, line_count, false, { message })
                        vim.api.nvim_set_option_value("modifiable", false, { buf = output_buf })
                    end
                    return
                end
                local layer = ui.layer(output_buf)
                local spec = require("dap.entity").variable.tree_spec
                local tree = ui.new_tree(spec)
                local lnum = vim.api.nvim_buf_line_count(output_buf)
                tree.render(layer, resp, nil, lnum, -1)
                vim.print("Result: " .. vim.inspect(resp))
            end)
        end,
    }
end, {})

return M
