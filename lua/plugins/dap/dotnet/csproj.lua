local M = {}
local utils = require("utils")

---@class CSProject
---@field dir string
---@field name string
---@field is_executable boolean
---@field target_framework string
---@field assembly_name string

---@param project_file string
---@param xml_root any
---@return CSProject|string
local function create_csproject(project_file, xml_root)
    local project = {}
    local property_group = xml_root["Project"]["PropertyGroup"]
    if property_group == nil then
        return "Missing PropertyGroup element in Project."
    end
    local target_framework = property_group["TargetFramework"]
    if target_framework == nil then
        return "Missing TargetFramework element in PropertyGroup."
    end
    project.target_framework = target_framework
    project.name = vim.fs.basename(project_file):sub(1, -8)
    local assembly_name = property_group["AssemblyName"]
    if assembly_name == nil then
        project.assembly_name = project.name
    else
        project.assembly_name = assembly_name
    end
    project.dir = vim.fs.dirname(project_file)
    local program_file = project.dir .. "/Program.cs"
    project.is_executable = utils.file_exists(program_file)
    return project
end

---@param project_file string
---@return CSProject|string?
function M.parse(project_file)
    local xml2lua = require("xml2lua")
    local handler = require("xmlhandler.tree")
    local file_handle, err_msg = io.open(project_file)
    if file_handle == nil then
        return err_msg
    end
    local xml_text = file_handle:read("*a")
    file_handle:close()
    local parser = xml2lua.parser(handler)
    parser:parse(xml_text)
    return create_csproject(project_file, handler.root)
end

return M
