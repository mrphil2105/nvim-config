return {
    "sbdchd/neoformat",
    config = function()
        local group = vim.api.nvim_create_augroup("Formatter", {})
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = group,
            command = "Neoformat",
        })
    end,
}
