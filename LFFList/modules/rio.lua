-- ------------------------------------------------------------------ --
-- Модуль реализующий вывод результатов в завивисимости от настроек   --
-- указанных пользователем (в файл и/или буфер обмена в               --
-- соответствующей кодировке                                          --
-- -----------------------------------------------------------------
local F = far.Flags
local M = far.GetMsg
-- ------------------------------------------------------------------ --
local rio = {}
local lib = require "lib"

-- Дискриптор открытого файла
rio.fh = nil
-- Флаг добавления в файл
rio.appendinfile = false
rio.charset = 'OEM'
rio.opt = {}
rio.currdir = ''
-- Получим ткущую дату
rio.t=os.time()
rio.currentDate=os.date("%Y-%m-%d", t)
rio.currentTime=os.date("%H:%M:%S", t)
-- Счётчик файлов
rio.FilesCount=0
-- -----------------------------------------------------------------
local function joinLists(a,b)
    for k,v in pairs(b) do
        a[k]=v
    end
    return a
end
-- Вычисления значения счётчика исходя из начального, текущего значений и
-- шага
local function getNum(n)
    return rio.opt.istart + (n-1)*rio.opt.istep
end
-- ------------------------------------------------------------------------
-- --      Массив соответствий для шаблона первой и последней строк     ---
-- ------------------------------------------------------------------------
local function getPattern(n)
    return {
        ["%%%%"]  = "%",
        ["%%R"]   = "\n",
        ["%%C"]   = rio.FilesCount,
        ["%%L"]   = rio.currdir,
        ["%%aL"]  = panel.GetPanelDirectory(nil, 1).Name,
        ["%%tT"]  = rio.currentTime,
        ["%%tY"]  = rio.currentDate,
        ["%%I"]   = getNum(n),
        ["%%oI"]  = getNum(n)+1,
        ["%%nI"]  = string.format("%0"..rio.opt.iwidth.."s", getNum(n)  ),
        ["%%sI"]  = string.format("%" ..rio.opt.iwidth.."s", getNum(n)  ),
        ["%%onI"] = string.format("%0"..rio.opt.iwidth.."s", getNum(n)+1),
        ["%%osI"] = string.format("%" ..rio.opt.iwidth.."s", getNum(n)+1),
        ["%%noI"] = string.format("%0"..rio.opt.iwidth.."s", getNum(n)+1),
        ["%%soI"] = string.format("%" ..rio.opt.iwidth.."s", getNum(n)+1),
    }
end
-- --------------------------------------------------------------------- --
--    Экранирование магических символов поисковых шаблонов символом %    --
-- --------------------------------------------------------------------- --
local function screening(s)
    return s:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])","%%%1")
end
-- --------------------------------------------------------------------- --
--              Получение относительного пути файла/каталога             --
-- --------------------------------------------------------------------- --
local function getRelativePath(file,currdir)
    currdir=screening(currdir)
    local rep=""
    local res=file:gsub("^"..currdir.."\\?",rep)
    while currdir:match("\\[^\\]+$") do
        if file:match("^"..currdir.."\\?") then break end
        currdir=currdir:gsub("\\[^\\]+$","")
        rep=rep.."..\\"
    end
    res=file:gsub("^"..currdir.."\\?",rep)
    return res
end
-- ------------------------------------------------------------------------
-- ------------------------------------------------------------------
-- @brief Открытие файла
-- @details В зависимости от настроек открывает файл (или не
--   открывает) создавая при этом новый файл или открывая
--   существующий файл для добавления строк результата (в зависимости
--   от настроек из диалога)
-- @param d dlg указатель на структуру данных диалога
-- @return
--   - filehandler - указатель на открытый файл, если в настройках
--     указано записывать в файл
--   - nil - при ошибке открытия файла, если в настройках указано
--     записывать в файл
--   - -1 - если в настройках указано не записывать в файл
-- ------------------------------------------------------------------
function rio.open(d)
	local drive,path, name, ext=lib.ParseFileName(d.filename)
    rio.currdir=far.GetCurrentDirectory()
    rio.opt=d
    filename=d.filename
	if path=="" and drive=="" and not filename:match("^\\") then
		path=far.GetCurrentDirectory()
    elseif path:match("^%.") then
		path=far.GetCurrentDirectory().."\\"..path
	end

	filename=drive..path.."\\"..name..(ext ~= "" and "."..ext or "")

    rio.charset = d.charset
    if d.appendinfile==1 then
        rio.appendinfile = true
    	rio.fh=io.open(filename,"a")
    else
        rio.appendinfile = false
    	rio.fh=io.open(filename,"w")
    end

	return rio.fh
end

-- Вывод шапки в соответствии с шаблоном
function rio.out_first()
    if rio.opt.first=="" then
    	return
    end
	rio.writeln(lib.repl(rio.opt.first, getPattern(1)))
end
-- Вывод подвала в соответствии с шаблоном
function rio.out_last()
    if rio.opt.last=="" then
    	return
    end
	rio.writeln(lib.repl(rio.opt.last, getPattern(rio.FilesCount)))
end
-- Вывод строки в соответствии с шаблоном
function rio.out(item)
    if not rio.isDir(item) then
        if rio.opt.skipfiles==1 then
            return
        end
    end
    if rio.isDir(item) then
        if item.StagingDirectory==1 and rio.opt.skipidirs==1 then
            return
        end
        if item.FilesCount==0 and rio.opt.skipempty==1 then
            return
        end
        if item.FilesCount~=0 and rio.opt.skipdir==1 then
            return
        end
    end
-- ------------------------------------------------------------------------------------------------
	local name, ext, drive, path, filename
	local f, p, p_D, p_sD, p_rD, p_rsD, p_mD, p_msD

	drive,path, name, ext=lib.ParseFileName(item.FileName)
	f = name..(ext~="" and "."..ext or "")
	p = drive..path
    p=p..(p~="" and "\\" or "")..f
        
    p_D=drive..path
    p_sD=string.gsub((p_D~="" and p_D.."\\" or ""),"\\+$","\\")

    p_rD=getRelativePath(drive..path,rio.currdir)
    p_rsD=string.gsub((p_rD~="" and p_rD.."\\" or ""),"\\+$","\\")

    p_mD=path
    p_msD=string.gsub((p_mD~="" and p_mD.."\\" or ""),"\\+$","\\")

    local pattern=getPattern(item.num)
    pattern=joinLists(pattern,{
        ["%%N"]   = name,
        ["%%fN"]   = (item.Attributes:match("D") and f or name),
        ["%%E"]   = ext,
        ["%%F"]   = f,

        ["%%D"]   = p_D,
        ["%%rD"]  = p_rD,
        ["%%mD"]  = p_mD,

        ["%%sD"]   = p_sD,
        ["%%rsD"]  = p_rsD,
        ["%%msD"]  = p_msD,

        ["%%V"]   = drive,
        ["%%P"]   = p,
        ["%%rP"]  = getRelativePath(p,rio.currdir),
        ["%%S"]   = item.FileSize,
        ["%%aS"]  = item.AllocationSize,

        ["%%fT"]  = item.Time.Change,
        ["%%cT"]  = item.Time.Creation,
        ["%%lT"]  = item.Time.LastAccess,
        ["%%wT"]  = item.Time.LastWrite,

        ["%%fY"] = item.Date.Change,
        ["%%cY"] = item.Date.Creation,
        ["%%lY"] = item.Date.LastAccess,
        ["%%wY"] = item.Date.LastWrite,

        ["%%fgT"]  = item.GTime.Change,
        ["%%cgT"]  = item.GTime.Creation,
        ["%%lgT"]  = item.GTime.LastAccess,
        ["%%wgT"]  = item.GTime.LastWrite,

        ["%%fgY"] = item.GDate.Change,
        ["%%cgY"] = item.GDate.Creation,
        ["%%lgY"] = item.GDate.LastAccess,
        ["%%wgY"] = item.GDate.LastWrite,

        ["%%A"]  = item.Attributes,
    })

	rio.writeln(lib.repl(rio.opt.format, pattern))
-- ------------------------------------------------------------------------------------------------
end

-- Вывод/невывод текста в файл, в зависимости от настроек
function rio.write(s)
    if rio.charset=="UTF-8" then
        rio.fh:write(s)
    else
        rio.fh:write(win.Utf8ToOem(s))
    end
end

-- Вывод/невывод строк в файл, в зависимости от настроек
function rio.writeln(s)
    rio.write(s.."\n")
end

-- Сброс файлового кэша на диск
function rio.flush()
    rio.fh:flush()
end

-- Закрытие файла
function rio.close()
    rio.fh:close()
end

-- Проверка - является ли файл директорией
function rio.isDir(item)
    if item.FileAttributes==nil then
        return false
    end
    return item.FileAttributes:match("d")=="d"
end

return rio
