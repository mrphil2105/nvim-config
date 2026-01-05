return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").install {
            "lua",
            "nix",
            "vim",
            "vimdoc",
            "bash",
            "make",
            "cmake",
            "c",
            "cpp",
            "rust",
            "c_sharp",
            "razor",
            "java",
            "kotlin",
            "scala",
            "python",
            "go",
            "proto",
            "erlang",
            "html",
            "css",
            "scss",
            "javascript",
            "typescript",
            "tsx",
            "graphql",
            "json",
            "yaml",
            "toml",
            "xml",
            "gitignore",
            "gitattributes",
            "regex",
            "sql",
            "dockerfile",
            "latex",
        }
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                local treesitter = require("nvim-treesitter")
                local lang = vim.treesitter.language.get_lang(args.match)
                if vim.list_contains(treesitter.get_installed(), lang) then vim.treesitter.start(args.buf) end
            end,
        })
    end,
}
