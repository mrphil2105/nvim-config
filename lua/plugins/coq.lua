return {
    "ms-jpq/coq_nvim",
    branch = "coq",
    dependencies = {
        {
            "ms-jpq/coq.artifacts",
            branch = "artifacts",
        },
    },
    init = function() require("plugins.coq.config").setup() end,
}
