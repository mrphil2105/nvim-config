local home_dir = os.getenv("HOME")
local luarocks_so = home_dir .. "/.luarocks/lib/lua/5.1/?.so"
local luarocks_lua = home_dir .. "/.luarocks/share/lua/5.1/?.lua"
package.cpath = package.cpath .. ";" .. luarocks_so
package.path = package.path .. ";" .. luarocks_lua

require("global")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
require("options")

vim.keymap.set("n", "<leader>/", "<Cmd>noh<CR>")
