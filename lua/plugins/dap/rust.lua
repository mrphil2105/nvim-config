local M = {}

local cargo_file_name = "Cargo.toml"

local function get_cargo_files()
    local utils = require("utils")

    local cwd = vim.fn.getcwd()
    local cwd_content = vim.split(vim.fn.glob(cwd .. "/*"), "\n", { trimempty = true })
    local cargo_files = {}

    local cargo_file = cwd .. "/" .. cargo_file_name

    if utils.file_exists(cargo_file) then table.insert(cargo_files, cargo_file) end

    for _, path in ipairs(cwd_content) do
        cargo_file = path .. "/" .. cargo_file_name
        local main_file = path .. "/src/main.rs"

        if vim.fn.isdirectory(path) and utils.file_exists(cargo_file) and utils.file_exists(main_file) then
            table.insert(cargo_files, cargo_file)
        end
    end

    return cargo_files
end

local is_building = false

local function register_build_keymap(cargo_files)
    local dap = require("dap")
    local utils = require("utils")

    vim.schedule(function()
        vim.keymap.set("n", "<leader>bc", function()
            if is_building then return end
            is_building = true
            vim.notify("Building Rust projects...")

            local success_count = 0
            local finished_count = 0
            local project_count = utils.table_length(cargo_files)

            for _, cargo_file in ipairs(cargo_files) do
                local working_dir = vim.fs.dirname(cargo_file)
                local on_exit = function(_, exit_code)
                    if exit_code == 0 then
                        success_count = success_count + 1

                        if success_count == project_count then
                            vim.notify("Build finished.")
                            dap.continue()
                        end
                    else
                        vim.notify("Cargo build failed with code: " .. exit_code)
                    end

                    finished_count = finished_count + 1
                    if finished_count == project_count then is_building = false end
                end

                local opts = {
                    cwd = working_dir,
                    on_exit = on_exit,
                }
                vim.fn.jobstart({ "cargo", "build" }, opts)
            end
        end, { desc = "Continue Execution" })
    end)
end

function M.setup()
    local cargo_files = get_cargo_files()

    if next(cargo_files) == nil then return end

    local dap = require("dap")
    local toml = require("toml")

    dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
            command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/codelldb",
            args = { "--port", "${port}" },
        },
    }

    local configs = {}

    for _, cargo_file in ipairs(cargo_files) do
        local success, cargo_manifest = pcall(toml.decodeFromFile, cargo_file)

        if not success then
            vim.api.nvim_err_writeln("Failed to decode Rust manifest: " .. vim.inspect(cargo_manifest))
            return
        end

        local working_dir = vim.fs.dirname(cargo_file)
        local config = {
            type = "codelldb",
            request = "launch",
            name = cargo_manifest.package.name,
            cwd = working_dir,
            program = working_dir .. "/target/debug/" .. cargo_manifest.package.name,
            stopOnEntry = false,
        }
        table.insert(configs, config)
    end

    register_build_keymap(cargo_files)
    dap.configurations.rust = configs
end

return M
