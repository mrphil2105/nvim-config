local M = {}

function M.setup()
    require("lspconfig.ui.windows").default_options.border = "single"
    vim.diagnostic.config {
        virtual_text = false,
        float = {
            border = "single",
        },
    }
end

return M
