return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup {
            ensure_installed = {
                "c",
                "lua",
                "vim",
                "vimdoc",
                "bash",
                "make",
                "cmake",
                "rust",
                "cpp",
                "c_sharp",
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
            },
            highlight = { enable = true },
            indent = { enable = true },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["aa"] = "@parameter.outer",
                        ["ia"] = "@parameter.inner",
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]m"] = "@function.outer",
                        ["]]"] = "@class.outer",
                    },
                    goto_next_end = {
                        ["]M"] = "@function.outer",
                        ["]["] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[m"] = "@function.outer",
                        ["[["] = "@class.outer",
                    },
                    goto_previous_end = {
                        ["[M"] = "@function.outer",
                        ["[]"] = "@class.outer",
                    },
                },
            },
        }
    end,
}
