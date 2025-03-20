local dap = require("dap")
local ui = require("ui")

local M = {}

function M.select_session()
    local table_sessions = dap.sessions()
    local list_sessions = {}
    for _, session in pairs(table_sessions) do
        table.insert(list_sessions, session)
    end
    local session = ui.select_if_many(list_sessions, "Session: ", function(session)
        return session.config.name
    end)
    return session
end

return M
