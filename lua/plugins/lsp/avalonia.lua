local M = {}

local lsp_env_var = "AVALONIA_LANGUAGE_SERVER"

local function axaml_root_dir(filename)
    local utils = require("utils")
    local root_pattern = require("lspconfig.util").root_pattern
    if not utils.has_file_extension(filename, ".axaml") then
        return nil
    end
    return root_pattern("*.sln")(filename)
end

function M.setup(capabilities)
    local configs = require("lspconfig.configs")

    if not configs.avalonia then
        local lsp_path = os.getenv(lsp_env_var)

        if lsp_path == nil then
            local error_msg = "Environment variable " .. lsp_env_var .. " must be set."
            vim.schedule(function()
                vim.api.nvim_err_writeln(error_msg)
            end)
            return
        end

        configs.avalonia = {
            default_config = {
                cmd = { "dotnet", lsp_path },
                root_dir = axaml_root_dir,
                filetypes = { "xml" },
            },
        }
    end

    require("lspconfig").avalonia.setup {
        capabilities = capabilities,
    }

    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        pattern = { "*.axaml" },
        callback = function()
            vim.cmd.setfiletype("xml")
        end,
    })
end

return M
