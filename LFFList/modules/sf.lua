local sf= {}
-- -----------------------------------------------------------------
-- ��������� ��������������� ������
-- -----------------------------------------------------------------
local M = far.GetMsg
local rio = require "rio"
local lib = require "lib"
-- �������� ���������� ��� ����������� ������
local hScr
local widthText=66
-- ���������� ���������� ������
local selCount=0

-- ��������������� ��������� ����� ���������� � �����
local function prepItem(item)
    item.Time={
        Change     = lib.FileTime.time(item.ChangeTime),
        Creation   = lib.FileTime.time(item.CreationTime),
        LastAccess = lib.FileTime.time(item.LastAccessTime),
        LastWrite  = lib.FileTime.time(item.LastWriteTime),
    }
    item.Date={
        Change     = lib.FileTime.date(item.ChangeTime),
        Creation   = lib.FileTime.date(item.CreationTime),
        LastAccess = lib.FileTime.date(item.LastAccessTime),
        LastWrite  = lib.FileTime.date(item.LastWriteTime),
    }
    item.GTime={
        Change     = lib.FileTime.gtime(item.ChangeTime),
        Creation   = lib.FileTime.gtime(item.CreationTime),
        LastAccess = lib.FileTime.gtime(item.LastAccessTime),
        LastWrite  = lib.FileTime.gtime(item.LastWriteTime),
    }
    item.GDate={
        Change     = lib.FileTime.gdate(item.ChangeTime),
        Creation   = lib.FileTime.gdate(item.CreationTime),
        LastAccess = lib.FileTime.gdate(item.LastAccessTime),
        LastWrite  = lib.FileTime.gdate(item.LastWriteTime),
    }
    item.Attributes = sf.fa2str(item.FileAttributes)

    return item
end


-- -----------------------------------------------------------------
-- ������������ ��������� � ����� ������
function sf.getFileList(item, opt)
    -- ������� ���������� ������
    rio.FilesCount=0
    -- ��������� ������ ���� Far'� � �������� ������ ������
    local farRect=far.AdvControl("ACTL_GETFARRECT")
    if farRect then
        local widthNew=farRect["Right"]-farRect["Left"]-13
        if widthNew > widthText then
            widthText = widthNew
        end
    end

    -- ������� ������ ����� ��� ������ �������� ������������
    hScr = far.SaveScreen(0, 0, -1, -1);
    local msg=(M(22)..string.rep(" ", widthText)):sub(1,widthText)
    far.Message(msg, M(5), "");


    local function find(item)
        local scount=0
        local ssize=0
        local sasize=0
        -- ���� �������������� ��������
        local sdflag=0
        item.FilesCount=0
        -- ������� �� ����� �������������� �������,  ���  ��  ������  ��  ������,
        -- �������� � ������ ��������� �� widthText ��������.
        local tfpath=(far.TruncPathStr(far.ConvertPath(item.FileName), widthText)..string.rep(" ", widthText)):sub(1,widthText)
        far.Message (tfpath, "","", "k");

        local function userfunc(item, fullname)
            local count=0
            local size=0
            local asize=0
            -- ���� �������������� ��������
            local lsdflag=0

            item.FileName=fullname
            if rio.isDir(item) then
                sdflag=1
                count, size, asize, lsdflag = find(item)
                scount = scount + count
                item.FileSize = size
                item.AllocationSize = asize
            else
                scount=scount+1
            end
            item.FilesCount = count
            item.StagingDirectory = lsdflag

            ssize=ssize+item.FileSize
            sasize=sasize+item.AllocationSize

            rio.FilesCount=rio.FilesCount+1
            item.num=rio.FilesCount
            rio.out(prepItem(item))
        end

        far.RecursiveSearch(far.ConvertPath(item.FileName), "*", userfunc)
        return scount, ssize, sasize, sdflag
    end

    item.FilesCount=0
    item.StagingDirectory=0
    if opt.recurse==1 and item.FileAttributes:match("d") then
        item.FilesCount, item.FileSize, item.AllocationSize, item.StagingDirectory = find(item)
    end
    rio.FilesCount=rio.FilesCount+1
    item.FileName=far.ConvertPath(item.FileName)
    item.num=rio.FilesCount
    rio.out(prepItem(item))

    -- ������� ������
    rio.out_last()
end

-- ------------------------------------------------------------------------- --
function  sf.get_selected_files(opt)
	local i, item

    res={}

    -- ������� ������ ���������� ����
	item=panel.GetSelectedPanelItem(nil,1,1)
    -- ���� ���������, ��� �� ���� ���� �� �������,
    -- �� ������ �� ���� ��� ��������
	if item == nil then
		item=panel.GetCurrentPanelItem (nil, 1)
	end

	i = 1

    -- �������� ����� �������� ��������, ���� ������ ����� �� �������� ".."
    local allfiles=false
    if item.FileName==".." then
        allfiles=true
        item=panel.GetPanelItem(nil, 1, 2)
        i = i + 1
    end

    -- ������� �����
    rio.out_first()

	while item ~= nil do
        sf.getFileList(item, opt)
        -- �������� ���������� ���������� ������ �� 1
		selCount = selCount + 1

		i = i + 1
        -- ������� �������� ���������� ����������� �����
        if allfiles then
            item = panel.GetPanelItem(nil, 1, i)
        else
    		item = panel.GetSelectedPanelItem(nil,1,i)
        end
	end
	if opt.unselected==1 then
		sf.unselected_files()
	end
end

-- ------------------------------------------------------------------------- --
-- @brief ������ ��������� � ������
-- @details ������� ��������� � ������
-- ------------------------------------------------------------------------- --
function sf.unselected_files()
	local i
    for i=1, selCount do
        panel.ClearSelection(nil,1,1)
    end
    selCount=0
    panel.RedrawPanel(nil,1)
end
-- ------------------------------------------------------------------------- --
-- ��������������� �������. ��������������� ���� FileAttributes ����� �
-- ������ ���� 'RAHSC', ��� ������ ������ ���������� ������� 
-- ���������������� ��������. � ������ ���������� ��������, ������ �������
-- �������� '-'.
-- ------------------------------------------------------------------------- --
function sf.fa2str(a)
    return --
        (a:match("d") and "D" or "-") .. --
        (a:match("r") and "R" or "-") .. --
        (a:match("a") and "A" or "-") .. --
        (a:match("h") and "H" or "-") .. --
        (a:match("s") and "S" or "-") .. --
        (a:match("c") and "C" or "-") .. --
        (a:match("e") and "E" or "-") .. --
        (a:match("p") and "P" or "-")
end

return sf
