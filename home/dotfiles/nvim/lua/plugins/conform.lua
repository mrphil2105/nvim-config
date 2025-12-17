local utils = require("utils")
return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "black" },
            typescript = { "biome" },
            typescriptreact = { "biome" },
            cs = { "csharpier" },
            java = { "clang-format" },
            c = { "clang-format" },
            cpp = { "clang-format" },
            rust = { "rustfmt" },
            xml = { "xstyler", "remove_bom" },
            nix = { "nixfmt" },
            css = { "cssbeautifier" },
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
            cssbeautifier = {
                command = "css-beautify",
                args = { "--stdin" },
                condition = function(_, ctx) return utils.has_file_extension(ctx.filename, ".css") end,
            },
        },
    },
    config = function(_, opts)
        local conform = require("conform")
        conform.setup(opts)
        local group = vim.api.nvim_create_augroup("Formatter", {})
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = group,
            callback = function(args) conform.format { bufnr = args.buf } end,
        })
    end,
}
