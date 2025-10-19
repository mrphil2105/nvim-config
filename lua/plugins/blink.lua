return {
    "saghen/blink.cmp",
    dependencies = { { "L3MON4D3/LuaSnip", version = "v2.*" }, "fang2hou/blink-copilot" },
    version = "1.*",
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
        completion = { documentation = { auto_show = true } },
        snippets = { preset = "luasnip" },
        sources = {
            default = { "lazydev", "lsp", "path", "snippets", "buffer", "copilot" },
            providers = {
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    score_offset = 100,
                },
                copilot = {
                    name = "copilot",
                    module = "blink-copilot",
                    score_offset = -1,
                    async = true,
                },
            },
        },
    },
    opts_extend = { "sources.default" },
}
