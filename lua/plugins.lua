return {
    -- Languages
    require("plugins.lsp"),
    require("plugins.treesitter"),

    -- Autocomplete
    require("plugins.cmp"),

    -- Files
    require("plugins.tree"),
    require("plugins.telescope"),

    -- Git
    require("plugins.gitsigns"),

    -- Terminal
    require("plugins.toggleterm"),

    -- Typing
    require("plugins.autopairs"),

    -- Visual
    require("plugins.tokyonight"),
    require("plugins.indent"),

    -- Formatting
    require("plugins.stylua"),
}
