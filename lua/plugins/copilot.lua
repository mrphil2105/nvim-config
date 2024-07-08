return {
    "zbirenbaum/copilot-cmp",
    dependencies = {
        {
            "zbirenbaum/copilot.lua",
            lazy = true,
            cmd = "Copilot",
            opts = {
                suggestion = { enabled = false },
                panel = { enabled = false },
            },
        },
    },
    opts = {},
}
