return {
    "stevearc/conform.nvim",
    config = function()
        local utils = require("utils")
        local conform = require("conform")

        conform.setup {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "black" },
                typescript = { "prettierd" },
                typescriptreact = { "prettierd" },
                cs = { "csharpier" },
                java = { "clang-format" },
                rust = { "rustfmt" },
                xml = { "xstyler", "remove_bom" },
            },
            formatters = {
                xstyler = {
                    command = "xstyler",
                    args = { "--loglevel", "None", "--file", "$FILENAME" },
                    stdin = false,
                    condition = function(_, ctx) return utils.has_file_extension(ctx.filename, ".axaml") end,
                },
                remove_bom = {
                    command = "dos2unix",
                    args = { "$FILENAME" },
                    stdin = false,
                    condition = function(_, ctx) return utils.has_file_extension(ctx.filename, ".axaml") end,
                },
            },
        }

        local group = vim.api.nvim_create_augroup("Formatter", {})
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = group,
            callback = function(args) conform.format { bufnr = args.buf } end,
        })
    end,
}
