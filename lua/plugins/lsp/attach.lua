local M = {}

function M.setup()
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            local buffer = args.buf

            if client == nil then
                return
            end

            local nmap = function(keys, func, desc)
                if desc then
                    desc = "LSP: " .. desc
                end

                vim.keymap.set("n", keys, func, { buffer = buffer, desc = desc })
            end

            nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
            nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
            nmap("<leader>ch", function()
                vim.lsp.buf.hover { border = "single" }
            end, "[C]ode [H]over")

            nmap("]d", function()
                vim.diagnostic.jump { count = 1, float = true }
            end, "Next [D]iagnostic")
            nmap("[d", function()
                vim.diagnostic.jump { count = -1, float = true }
            end, "Prev [D]iagnostic")

            local builtin = require("telescope.builtin")
            nmap("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
            nmap("gr", builtin.lsp_references, "[G]oto [R]eferences")
            nmap("gi", builtin.lsp_implementations, "[G]oto [I]mplementation")
            nmap("td", builtin.lsp_type_definitions, "[T]ype [D]efinition")
            nmap("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
        end,
    })
end

return M
