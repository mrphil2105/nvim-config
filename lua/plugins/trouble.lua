return {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {
        focus = true,
        modes = {
            diagnostics = {
                filter = function(items)
                    return vim.tbl_filter(function(item)
                        return not string.match(item.basename, [[%__virtual.cs$]])
                    end, items)
                end,
            },
        },
    },
    keys = {
        {
            "<leader>xx",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)",
        },
        {
            "<leader>xX",
            "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
            desc = "Buffer Diagnostics (Trouble)",
        },
        {
            "<leader>xs",
            "<cmd>Trouble symbols toggle<cr>",
            desc = "Symbols (Trouble)",
        },
        {
            "gR",
            "<cmd>Trouble lsp toggle<cr>",
            desc = "LSP References (Trouble)",
        },
        {
            "<leader>xl",
            "<cmd>Trouble loclist toggle<cr>",
            desc = "Location List (Trouble)",
        },
        {
            "<leader>xq",
            "<cmd>Trouble qflist toggle<cr>",
            desc = "Quickfix List (Trouble)",
        },
    },
}
