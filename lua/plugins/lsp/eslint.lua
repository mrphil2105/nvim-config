return function(client, buffer)
    if client.name == "eslint" then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = buffer,
            command = "EslintFixAll",
        })
        vim.cmd("EslintFixAll")
    end
end
