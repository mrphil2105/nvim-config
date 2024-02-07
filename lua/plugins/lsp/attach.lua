---@diagnostic disable-next-line: unused-local
return function(client, buffer)
    local nmap = function(keys, func, desc)
        if desc then desc = "LSP: " .. desc end

        vim.keymap.set("n", keys, func, { buffer = buffer, desc = desc })
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    nmap("<leader>ch", vim.lsp.buf.hover, "[C]ode [H]over")

    nmap("]d", vim.diagnostic.goto_next, "Next [D]iagnostic")
    nmap("[d", vim.diagnostic.goto_prev, "Prev [D]iagnostic")

    local builtin = require("telescope.builtin")
    nmap("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
    nmap("gr", builtin.lsp_references, "[G]oto [R]eferences")
    nmap("gi", builtin.lsp_implementations, "[G]oto [I]mplementation")
    nmap("td", builtin.lsp_type_definitions, "[T]ype [D]efinition")
    nmap("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
end
