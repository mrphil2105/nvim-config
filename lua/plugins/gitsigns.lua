return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup {
            on_attach = function(buffer)
                local gs = require("gitsigns")

                local nmap = function(keys, func, opts)
                    opts = opts or {}
                    opts.buffer = buffer
                    vim.keymap.set("n", keys, func, opts)
                end

                -- Navigation
                nmap("]c", function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true })

                nmap("[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true })

                -- Actions
                nmap("<leader>hs", gs.stage_hunk)
                nmap("<leader>hr", gs.reset_hunk)
                nmap("<leader>hS", gs.stage_buffer)
                nmap("<leader>hu", gs.undo_stage_hunk)
                nmap("<leader>hR", gs.reset_buffer)
                nmap("<leader>hp", gs.preview_hunk)
                nmap("<leader>hb", function()
                    gs.blame_line { full = true }
                end)
                nmap("<leader>tb", gs.toggle_current_line_blame)
                nmap("<leader>hd", gs.diffthis)
                nmap("<leader>hD", function()
                    gs.diffthis("~")
                end)
                nmap("<leader>td", gs.toggle_deleted)
            end,
        }
    end,
}
