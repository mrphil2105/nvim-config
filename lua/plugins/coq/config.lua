local M = {}

function M.setup()
    vim.g.coq_settings = {
        auto_start = "shut-up",
        display = {
            preview = {
                border = "single",
            },
            ghost_text = {
                enabled = false,
            },
        },
    }
end

return M
