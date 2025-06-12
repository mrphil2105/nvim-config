return {
    clangd = {},
    lua_ls = {
        Lua = {
            workspace = {
                checkThirdParty = "Disable",
            },
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
    rust_analyzer = {},
    pylsp = {},
}
