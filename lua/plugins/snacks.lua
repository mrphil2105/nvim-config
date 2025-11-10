local excluded_files = { "*__virtual.cs" }
return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        picker = {
            enabled = true,
            formatters = {
                file = {
                    truncate = 80,
                },
            },
        },
    },
    keys = {
        {
            "<leader>f<space>",
            function()
                Snacks.picker.pickers()
            end,
            desc = "All Pickers",
        },
        {
            "<leader>ff",
            function()
                Snacks.picker.files { exclude = excluded_files }
            end,
            desc = "Find Files",
        },
        {
            "<leader>fg",
            function()
                Snacks.picker.grep { exclude = excluded_files }
            end,
            desc = "Grep",
        },
        {
            "<leader>fw",
            function()
                Snacks.picker.grep_word { exclude = excluded_files }
            end,
            desc = "Grep Word",
        },
        {
            "<leader>fb",
            function()
                Snacks.picker.buffers()
            end,
            desc = "Buffers",
        },
        {
            "<leader>fl",
            function()
                Snacks.picker.git_log()
            end,
            desc = "Git Log",
        },
        {
            "<leader>fc",
            function()
                Snacks.picker.git_log_file()
            end,
            desc = "Git Log File",
        },
        {
            "<leader>fh",
            function()
                Snacks.picker.help()
            end,
            desc = "Help Pages",
        },
        {
            "<leader>fr",
            function()
                Snacks.picker.resume()
            end,
            desc = "Resume",
        },
        {
            "gd",
            function()
                Snacks.picker.lsp_definitions()
            end,
            desc = "Goto Definition",
        },
        {
            "gD",
            function()
                Snacks.picker.lsp_declarations()
            end,
            desc = "Goto Declaration",
        },
        {
            "gr",
            function()
                Snacks.picker.lsp_references()
            end,
            nowait = true,
            desc = "References",
        },
        {
            "gi",
            function()
                Snacks.picker.lsp_implementations()
            end,
            desc = "Goto Implementation",
        },
        {
            "gy",
            function()
                Snacks.picker.lsp_type_definitions()
            end,
            desc = "Goto Type Definition",
        },
    },
}
