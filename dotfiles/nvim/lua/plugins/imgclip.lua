return {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
        default = {
            dir_path = "images",
            relative_to_current_file = true,
        },
        filetypes = {
            tex = { relative_template_path = true },
        },
    },
}
