return {
    "stevearc/conform.nvim",
    config = function()
        local conform = require("conform")
        conform.setup {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "black" },
                typescript = { "prettierd" },
                typescriptreact = { "prettierd" },
                cs = { "csharpier" },
            },
        }

        local group = vim.api.nvim_create_augroup("Formatter", {})
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = group,
            callback = function(args) conform.format { bufnr = args.buf } end,
        })
    end,
}
