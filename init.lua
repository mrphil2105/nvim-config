local home_dir = os.getenv("HOME")
local luarocks_so = home_dir .. "/.luarocks/lib/lua/5.1/?.so"
package.cpath = package.cpath .. ";" .. luarocks_so

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
