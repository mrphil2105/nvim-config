local servers = require("config.lsp.servers")
for server_name, settings in pairs(servers) do
    local cmd = settings.cmd
    settings.cmd = nil
    vim.lsp.config[server_name] = {
        settings = settings,
        filetypes = settings.filetypes,
        cmd = cmd,
    }
    vim.lsp.enable(server_name)
end
require("config.lsp.avalonia")
require("config.lsp.attach")
require("config.lsp.ui")
