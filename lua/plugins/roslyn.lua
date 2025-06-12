return {
    "seblyng/roslyn.nvim",
    dependencies = {
        {
            "tris203/rzls.nvim",
            opts = {},
        },
        "jlcrochet/vim-razor",
    },
    ft = { "cs", "razor" },
    config = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
        require("roslyn").setup {
            exe = "Microsoft.CodeAnalysis.LanguageServer",
            args = {
                "--stdio",
                "--logLevel=Information",
                "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
                "--razorSourceGenerator=" .. vim.fs.joinpath(
                    os.getenv("RZLS_PATH") --[[@as string]],
                    "lib",
                    "rzls",
                    "Microsoft.CodeAnalysis.Razor.Compiler.dll"
                ),
                "--razorDesignTimePath=" .. vim.fs.joinpath(
                    os.getenv("RZLS_PATH") --[[@as string]],
                    "lib",
                    "rzls",
                    "Targets",
                    "Microsoft.NET.Sdk.Razor.DesignTime.targets"
                ),
            },
            ---@diagnostic disable-next-line: missing-fields
            config = {
                handlers = require("rzls.roslyn_handlers"),
                capabilities = capabilities,
            },
        }
    end,
    init = function()
        vim.filetype.add {
            extension = {
                razor = "razor",
                cshtml = "razor",
            },
        }
    end,
}
