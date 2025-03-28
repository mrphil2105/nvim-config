local home_dir = os.getenv("HOME")
local luarocks_so = home_dir .. "/.luarocks/lib/lua/5.1/?.so"
local luarocks_lua = home_dir .. "/.luarocks/share/lua/5.1/?.lua"
package.cpath = package.cpath .. ";" .. luarocks_so
package.path = package.path .. ";" .. luarocks_lua
