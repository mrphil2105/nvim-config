return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()
    end,
    keys = {
        { "<leader>a", function() require("harpoon"):list():add() end },
        { "<C-e>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end },
        { "<M-1>", function() require("harpoon"):list():select(1) end },
        { "<M-2>", function() require("harpoon"):list():select(2) end },
        { "<M-3>", function() require("harpoon"):list():select(3) end },
        { "<M-4>", function() require("harpoon"):list():select(4) end },
        { "<M-5>", function() require("harpoon"):list():select(5) end },
        { "<M-6>", function() require("harpoon"):list():select(6) end },
        { "<M-7>", function() require("harpoon"):list():select(7) end },
        { "<M-8>", function() require("harpoon"):list():select(8) end },
        { "<M-9>", function() require("harpoon"):list():select(9) end },
        { "<M-0>", function() require("harpoon"):list():select(10) end },
        { "<C-S-P>", function() require("harpoon"):list():prev() end },
        { "<C-S-N>", function() require("harpoon"):list():next() end },
    },
}
