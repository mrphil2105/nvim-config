local M = {}

function M.setup()
    require("lspconfig.ui.windows").default_options.border = "single"

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
    vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })

    vim.diagnostic.config {
        virtual_text = false,
        float = {
            border = "single",
        },
    }
end

return M
