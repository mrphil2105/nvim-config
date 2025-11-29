vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local buffer = args.buf
        if client == nil then return end
        local nmap = function(keys, func, desc)
            if desc then desc = "LSP: " .. desc end
            vim.keymap.set("n", keys, func, { buffer = buffer, desc = desc })
        end
        nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
        nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
        nmap("<leader>ch", function() vim.lsp.buf.hover { border = "single" } end, "Code Hover")
        nmap("]d", function() vim.diagnostic.jump { count = 1, float = true } end, "Next Diagnostic")
        nmap("[d", function() vim.diagnostic.jump { count = -1, float = true } end, "Prev Diagnostic")
    end,
})
