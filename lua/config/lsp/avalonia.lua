local lsp_path = os.getenv("AVALONIA_LSP_SERVER")
if lsp_path == nil then return end
vim.filetype.add { extension = { axaml = "axaml" } }
vim.lsp.config.avalonia = {
    cmd = { "dotnet", lsp_path },
    root_dir = vim.fs.root(0, function(name) return name:match("%.sln$") or name:match("%.csproj$") end),
    filetypes = { "axaml" },
}
vim.lsp.enable("avalonia")
vim.treesitter.language.register("xml", "axaml")
