local lua_path = os.getenv("LUA_PATH")
local lua_cpath = os.getenv("LUA_CPATH")
package.cpath = package.cpath .. ";" .. lua_path
package.path = package.path .. ";" .. lua_cpath
