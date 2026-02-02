local servers = require("config.lsp.servers")
for server_name, settings in pairs(servers) do
    local cmd = settings.cmd
    local filetypes = settings.filetypes
    settings.cmd = nil
    settings.filetypes = nil
    vim.lsp.config[server_name] = {
        settings = settings,
        filetypes = filetypes,
        cmd = cmd,
    }
    vim.lsp.enable(server_name)
end
require("config.lsp.avalonia")
require("config.lsp.attach")
require("config.lsp.ui")
