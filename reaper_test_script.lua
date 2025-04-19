
-- At the start of the script copy this:
-- Instead of " reaper.GetResourcePath() ..'Scripts/Daniel Lumertz Scripts/LUA Socket/socket module/' " put the path for your socket module folder. The folder that hold all lua modules files AND the "socket" folder
--[[package.cpath = package.cpath .. ";" .. reaper.GetResourcePath() ..'/Scripts/Lua Sockets/socket module/?.dll'    -- WINDOWS ONLY: Add socket module path for .dll files
package.path = package.path .. ";" .. reaper.GetResourcePath()   ..'/Scripts/Lua Sockets/socket module/?.lua'      -- Add all lua socket modules to the path  
]]--require("mobdebug").start() -- Start mobdebug module


---@diagnostic disable-next-line: undefined-global
reaper.ShowConsoleMsg("hello world")


