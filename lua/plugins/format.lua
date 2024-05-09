local function format_xaml()
    local utils = require("utils")
    local random_filename = utils.get_random_filename() .. ".axaml"
    local random_filepath = "/tmp/" .. random_filename
    local file, err_msg = io.open(random_filepath, "w")

    if file == nil then
        vim.notify("Unable to format XAML: " .. err_msg, vim.log.levels.ERROR)
        return
    end

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for _, line in ipairs(lines) do
        file:write(line .. "\n")
    end
    file:close()

    local formatted = vim.fn.system {
        "xstyler",
        "--write-to-stdout",
        "--loglevel",
        "None",
        "--file",
        random_filepath,
    }
    os.remove(random_filepath)

    lines = {}
    for line in formatted:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    utils.remove_bom()
end

return {
    "sbdchd/neoformat",
    init = function() vim.g.neoformat_enabled_cs = { "csharpier" } end,
    config = function()
        local group = vim.api.nvim_create_augroup("Formatter", {})
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = group,
            callback = function()
                local extension = vim.fn.expand("%:e")
                if extension == "axaml" then
                    format_xaml()
                elseif extension ~= "csproj" then
                    vim.cmd("Neoformat")
                end
            end,
        })
    end,
}
