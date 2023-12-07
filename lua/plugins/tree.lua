return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        tab = {
            sync = {
                open = true,
            },
        },
        renderer = {
            root_folder_label = false,
        },
        filters = {
            custom = { ".git" },
        },
    },
}
