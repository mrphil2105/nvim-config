local M = {}

---@class CSProject
---@field dir string
---@field name string
---@field is_executable boolean
---@field target_framework string
---@field assembly_name string

---@param project_file string
---@param xml_document any
---@return CSProject|string
local function create_csproject(project_file, xml_document)
    local project = {}
    local utils = require("utils")

    local root = xml_document:root()
    local property_group = root:search("PropertyGroup")[1]
    if property_group == nil then
        return "Missing PropertyGroup element in Project."
    end

    local target_framework = property_group:search("TargetFramework")[1]
    if target_framework == nil then
        return "Missing TargetFramework element in PropertyGroup."
    end
    project.target_framework = target_framework:text()

    project.dir = vim.fs.dirname(project_file)
    project.name = vim.fs.basename(project_file):sub(1, -8)

    local assembly_name = property_group:search("AssemblyName")[1]
    if assembly_name == nil then
        project.assembly_name = project.name
    else
        project.assembly_name = assembly_name:text()
    end

    local dir_name = vim.fs.dirname(project_file)
    local program_file = dir_name .. "/Program.cs"
    project.is_executable = utils.file_exists(program_file)

    return project
end

---@param project_file string
---@return CSProject|string?
function M.parse(project_file)
    local xmlua = require("xmlua")
    local file_handle, err_msg = io.open(project_file)
    if file_handle == nil then
        return err_msg
    end

    local xml = file_handle:read("*a")
    file_handle:close()
    local success, xml_document = pcall(xmlua.XML.parse, xml)
    if not success then
        return xml_document
    end

    return create_csproject(project_file, xml_document)
end

return M
