-- -----------------------------------------------------------------
-- Подключим вспомогательные модули
-- -----------------------------------------------------------------
local F = far.Flags
local M = far.GetMsg

-- Массив найденных файлов
local res={}

-- -----------------------------------------------------------------
local function joinLists(a,b)
    for k,v in pairs(b) do
        a[k]=v
    end
    return a
end

-- -----------------------------------------------------------------
local main={}
function main.Open(OpenFrom, Guid, Item)
    package.loaded.rio=nil
    local rio = require "rio"

    package.loaded.sf=nil
    local sf = require "sf"

    package.loaded.dlg=nil
    local dlg = require "dlg"

    repeat
    	-- Вызываем диалог плагина
    	local ret = dlg.run()
    	-- Если пользователь не нажал кнопку "Создать" то валим от
    	-- сюда без продолжения каких либо действий
    	if ret ~= 1 then return end

    	local fh=rio.open(dlg.data)
    	if fh == nil then
    		far.Message(M(2).."\n"..dlg.data.filename, M(1), ";Ok", "w")
    	end
    until fh ~= nil

    sf.get_selected_files(dlg.data)
    rio.flush()
	rio.close()
end
return main