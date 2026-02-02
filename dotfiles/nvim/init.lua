local has_generated = pcall(require, "hm-generated")
if not has_generated then vim.notify("hm-generated.lua not found", vim.log.levels.WARN) end
require("config.lazy")
require("config.lsp")
require("config.options")
require("config.keymaps")
