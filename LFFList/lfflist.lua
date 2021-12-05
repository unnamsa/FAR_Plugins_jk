-- Укажем где искать вспомогательные  модули
package.loaded.main=nil
package.path = far.PluginStartupInfo().ModuleDir .. "modules\\?.lua;" .. package.path
local main=require "main"
local mTitle = 0
local F = far.Flags
local M = far.GetMsg

local myGuid = win.Uuid("5c9f2475-4404-416a-93a5-94fad09a729c")

function export.GetPluginInfo()
  return {
    Flags = F.PF_NONE,
    PluginMenuGuids   = myGuid.."",
    PluginMenuStrings = { M(mTitle) },
  }
end

function export.Open(OpenFrom, Guid, Item)
    main.Open(OpenFrom, Guid, Item)
end
