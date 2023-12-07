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
    tsserver = {}
}

require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers)
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(client, buffer)
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = buffer, desc = desc })
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    nmap("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
    nmap("<leader>td", require("telescope.builtin").lsp_type_definitions, "[T]ype [D]efinition")
    nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

    if client.name == "eslint" then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = buffer,
            command = "EslintFixAll"
        })
        vim.cmd("EslintFixAll")
    end

    vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = buffer,
        callback = function()
            if client.name == "lua_ls" then
                require("stylua-nvim").format_file()
            else
                vim.lsp.buf.format({
                    filter = function(c)
                        return c.id == client.id
                    end
                })
            end
        end
    })
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

require("lsp_signature").setup {
    handler_opts = {
        border = "single"
    }
}
