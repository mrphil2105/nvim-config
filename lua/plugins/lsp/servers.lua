return {
    clangd = {
        cmd = {
            "clangd",
            "--offset-encoding=utf-16",
        },
    },
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
    tsserver = {},
    pylsp = {},
}
