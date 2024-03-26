return {
    "sbdchd/neoformat",
    init = function() vim.g.neoformat_enabled_cs = { "csharpier" } end,
    config = function()
        local group = vim.api.nvim_create_augroup("Formatter", {})
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = group,
            command = "Neoformat",
        })
    end,
}
