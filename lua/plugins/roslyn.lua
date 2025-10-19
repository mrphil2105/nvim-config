return {
    "seblyng/roslyn.nvim",
    dependencies = {
        {
            "tris203/rzls.nvim",
            config = function()
                local rzls_base_path = vim.fs.joinpath(os.getenv("RZLS_PATH"), "lib", "rzls")
                local cmd = {
                    "Microsoft.CodeAnalysis.LanguageServer",
                    "--stdio",
                    "--logLevel=Information",
                    "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
                    "--razorSourceGenerator="
                        .. vim.fs.joinpath(rzls_base_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
                    "--razorDesignTimePath="
                        .. vim.fs.joinpath(rzls_base_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
                }
                local capabilities = require("blink.cmp").get_lsp_capabilities()
                vim.lsp.config("roslyn", {
                    cmd = cmd,
                    handlers = require("rzls.roslyn_handlers"),
                    capabilities = capabilities,
                })
                require("rzls").setup {
                    path = "rzls",
                    capabilities = capabilities,
                    -- Handled by an autocommand in attach.lua.
                    on_attach = function() end,
                }
            end,
        },
        "jlcrochet/vim-razor",
    },
    ft = { "cs", "razor" },
    config = true,
    init = function()
        vim.filetype.add {
            extension = {
                razor = "razor",
                cshtml = "razor",
            },
        }
    end,
}
