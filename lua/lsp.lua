local servers = {
    clangd = {},
    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            diagnostics = {
                globals = { "vim" }
            },
            telemetry = { enable = false },
        },
    },
}

require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers)
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(client, buffer)
    if client.name == "eslint" then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = buffer,
            command = "EslintFixAll"
        })
        vim.cmd("EslintFixAll")
    end
end

mason_lspconfig.setup_handlers {
    function(server_name)
        require("lspconfig")[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes
        }
    end
}
