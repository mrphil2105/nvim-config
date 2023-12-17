return function(client, buffer)
    vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = buffer,
        callback = function()
            if client.name == "lua_ls" then
                require("stylua-nvim").format_file()
            else
                vim.lsp.buf.format {
                    filter = function(c) return c.id == client.id end,
                }
            end
        end,
    })
end
