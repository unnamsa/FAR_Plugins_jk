local GUID = "E129CB4A-03A6-434B-B1F3-A19C6258ECBC"       -- HIVER plugin GUID
local ffi  = require "ffi"

ffi.cdef [[
    typedef struct { uint32_t nOffs;     uint32_t nLen;     uint32_t nFlag; }  ElmRef;

    typedef struct { ElmRef   SD;        ElmRef   Name;     ElmRef   FullNm;
                     ElmRef   Desc;      ElmRef   Unk1;     ElmRef   Unk2;
                     ElmRef   Home;      ElmRef   NetDrv;   ElmRef   Script;
                     ElmRef   Profile;   ElmRef   Unk3;     ElmRef   Unk4;
                     ElmRef   Unk5;      ElmRef   LMCh;     ElmRef   NTCh;
                     ElmRef   Unk6;      ElmRef   Unk7;                     }  VHeader;
 
    typedef struct { ElmRef   SD;        ElmRef   Name;     ElmRef   Desc;
                     uint32_t nOffsList; uint32_t nLenList; uint32_t nMembers; } CHeader;

    typedef struct { uint64_t Unk1;                                            uint64_t tLastLogin;
                     uint64_t Unk2;                                            uint64_t tCreated;
                     uint64_t tExpire;                                         uint64_t tLoginFail; 
                     uint32_t nRID;                         uint32_t Unk3;     uint32_t nFlags;     uint32_t Unk4;
                     uint16_t nFailCnt;  uint16_t nLgnCnt;  uint32_t Unk5;     uint32_t nNextRID;   uint32_t Unk6;
                     uint64_t Unk7;                                            uint64_t Unk8;
                     uint64_t Unk9;                                            uint64_t Unk10;
                     uint64_t BootCache1;                                      uint64_t BootCache11;
                     uint64_t BootCache2;                                      } FRecord;
]]

return {

-- Parse an Account descriptor. 
-- Data is a string, containing registry value.
Parse_F = function (Data)

    --  Check the data
    if  #Data < 0x50     then  return  nil, "Data is too short" end         -- Check the minimum data length

    -- Data format: 0 - user account; 1 - SAM/Domains/Account; 2 - SAM/Domains/Builtin
    local ret    = {}
    local cRec   = ffi.cast ("FRecord*", Data)
    ret.nFormat  = (#Data < 0x70) and 0  or  ((#Data >= 0xA0  and  tonumber(cRec.BootCache1) ~= 0) and 1 or 2)

    if  ret.nFormat == 0  then
        -- Extract a usual account's fields
        ret.nOffsLastLogin = ffi.offsetof ("FRecord", "tLastLogin")
        ret.tLastLogin     = tonumber (cRec.tLastLogin)

        ret.nOffsCreated   = ffi.offsetof ("FRecord", "tCreated")
        ret.tCreated       = tonumber (cRec.tCreated)

        ret.nOffsExpire    = ffi.offsetof ("FRecord", "tExpire")
        ret.tExpire        = tonumber (cRec.tExpire)

        ret.nOffsLoginFail = ffi.offsetof ("FRecord", "tLoginFail")
        ret.tLoginFail     = tonumber (cRec.tLoginFail)

        ret.nOffsRID       = ffi.offsetof ("FRecord", "nRID")
        ret.nRID           = tonumber (cRec.nRID)
        ret.sRIDType       = "User RID"

        ret.nOffsFlags     = ffi.offsetof ("FRecord", "nFlags")
        ret.nFlags         = tonumber (cRec.nFlags)

        ret.nOffsFailCnt   = ffi.offsetof ("FRecord", "nFailCnt")
        ret.nFailCnt       = tonumber (cRec.nFailCnt)

        ret.nOffsLgnCnt    = ffi.offsetof ("FRecord", "nLgnCnt")
        ret.nLgnCnt        = tonumber (cRec.nLgnCnt)
    else
        ret.nOffsCreated   = ffi.offsetof ("FRecord", "tLastLogin")               -- YES, it is NOT a MISTAKE!
        ret.tCreated       = tonumber (cRec.tLastLogin)

        ret.nOffsRID       = ffi.offsetof ("FRecord", "nNextRID")
        ret.nRID           = tonumber (cRec.nNextRID)
        ret.sRIDType       = (ret.nFormat == 1) and "Next available RID" or "First non-builtin User RID"

        if  ret.nFormat == 1  then
            ret.nOffsBootCache1 = ffi.offsetof ("FRecord", "BootCache1")
            ret.sBootCache1     = string.char(string.byte( Data, ret.nOffsBootCache1 +1, ret.nOffsBootCache1 +0x10 ))
            ret.nOffsBootCache2 = ffi.offsetof ("FRecord", "BootCache2")
            ret.sBootCache2     = string.char(string.byte( Data, ret.nOffsBootCache2 +1, ret.nOffsBootCache2 +0x20 ))
        end
    end

    return  ret
end,


-- Parse a User descriptor. 
-- Data is a string, containing registry value.
Parse_V = function (Data)

    --  Check the data
    if  #Data < 0x34     then  return  nil, "Data is too short" end         -- Check the minimum header length
    local cValue = ffi.cast ("uint32_t*",  Data)
    local nStart = (cValue[0x30/4]>=0x80000000) and 0x30 or 0xCC            -- The Header length (0x80 - "self-relative" SD flag)
    if  #Data < nStart   then  return  nil, "Header size exceeds the data length" end
    local nRecLen= nStart
    for i = 0, nStart/12 -1  do nRecLen = nRecLen + cValue[i*3 +1] end      -- Summarize the UD's fields lengths
    if  #Data < nRecLen  then  return  nil, "Invalid data header"  end      -- Check the total UserDescriptor length

    --  At last, we're ready to parse :-)
    local cHdr   = ffi.cast ("VHeader*", Data)
    local ret    = {}
    ret.nFormat  = (nStart == 0x30) and 0 or 1

    -- Extract Security Descrptor (make it table type to be ready to pass it to "parse SecDesc")
    ret.nOffsSD  = nStart
    ret.nLenSD   = tonumber(cHdr.SD.nLen)
    ret.SD       = { string.char(string.byte(Data, ret.nOffsSD+1, ret.nOffsSD+ret.nLenSD)) }

--local s0 = string.char(0xDA, 0x8B, 0x7F)   -- What is why string.sub()  is not suitable for work with binary data!
--far.Message(#s0, "#s0")
--far.Message(#s0:sub(1, 1), 1)
--far.Message(#s0:sub(1, 2), 2)
--far.Message(#s0:sub(1, 3), 3)


    if  (ret.nFormat == 0)  then
        -- Extract and parse the machine wide SID
        ret.nOffsSID   = nStart + tonumber(cHdr.Name.nOffs)
        ret.nLenSID    = tonumber(cHdr.Name.nLen)
        local Names,Values,Descs,Offsets,Lengths,Depths = Plugin.SyncCall (GUID, nil, "parse SID", {Data}, ret.nOffsSID)
        ret.sMachSID   = Values[1]
    else
        -- Extract the user's related fields
        ret.nOffsName  = nStart + tonumber(cHdr.Name.nOffs)
        ret.nLenName   = tonumber(cHdr.Name.nLen)
        ret.sUserName  = win.Utf16ToUtf8  (string.char(string.byte(Data, ret.nOffsName+1, ret.nOffsName+ret.nLenName)))

        ret.nOffsFName = nStart + tonumber(cHdr.FullNm.nOffs)
        ret.nLenFName  = tonumber(cHdr.FullNm.nLen)
        ret.sUserFName = win.Utf16ToUtf8  (string.char(string.byte(Data, ret.nOffsFName+1, ret.nOffsFName+ret.nLenFName)))

        ret.nOffsComm  = nStart + tonumber(cHdr.Desc.nOffs)
        ret.nLenComm   = tonumber(cHdr.Desc.nLen)
        ret.sComment   = win.Utf16ToUtf8  (string.char(string.byte(Data, ret.nOffsComm+1, ret.nOffsComm+ret.nLenComm)))

        ret.nOffsHome  = nStart + tonumber(cHdr.Home.nOffs)
        ret.nLenHome   = tonumber(cHdr.Home.nLen)
        ret.sHomeDir   = win.Utf16ToUtf8  (string.char(string.byte(Data, ret.nOffsHome+1, ret.nOffsHome+ret.nLenHome)))

        ret.nOffsNDrv  = nStart + tonumber(cHdr.NetDrv.nOffs)
        ret.nLenNDrv   = tonumber(cHdr.NetDrv.nLen)
        ret.sNetDrive  = win.Utf16ToUtf8  (string.char(string.byte(Data, ret.nOffsNDrv+1, ret.nOffsNDrv+ret.nLenNDrv)))

        ret.nOffsScrp  = nStart + tonumber(cHdr.Script.nOffs)
        ret.nLenScrp   = tonumber(cHdr.Script.nLen)
        ret.sScriptNm  = win.Utf16ToUtf8  (string.char(string.byte(Data, ret.nOffsScrp+1, ret.nOffsScrp+ret.nLenScrp)))

        ret.nOffsProf  = nStart + tonumber(cHdr.Profile.nOffs)
        ret.nLenProf   = tonumber(cHdr.Profile.nLen)
        ret.sProfDir   = win.Utf16ToUtf8  (string.char(string.byte(Data, ret.nOffsProf+1, ret.nOffsProf+ret.nLenProf)))

        ret.nOffsLMCh  = nStart + tonumber(cHdr.LMCh.nOffs +4)
        ret.nLenLMCh   = tonumber(cHdr.LMCh.nLen -4)
        ret.LMCache    = { string.char(string.byte(Data, ret.nOffsLMCh+1, ret.nOffsLMCh+ret.nLenLMCh)) }

        ret.nOffsNTCh  = nStart + tonumber(cHdr.NTCh.nOffs +4)
        ret.nLenNTCh   = tonumber(cHdr.NTCh.nLen -4)
        ret.NTCache    = { string.char(string.byte(Data, ret.nOffsNTCh+1, ret.nOffsNTCh+ret.nLenNTCh)) }
    end

    return  ret
end,


-- Parse a Group descriptor. 
-- Data is a string, containing registry value.
Parse_C = function (Data)

    -- Discover the GD format
    local cValue = ffi.cast ("uint32_t*",  Data)
    local nFmt   = tonumber (cValue[0])
    local nStart = (nFmt==0x00010007) and 0x10  or  ((nFmt==0x00010002) and 0x44  or 0x34)
    local cHdr   = ffi.cast ("CHeader*", string.char(string.byte(Data, (nFmt==0x00010002) and 21 or 5, nStart )))
    local ret    = {}
    ret.nFormat  = (nFmt == 0x00010007) and 0  or  ((nFmt == 0x00010002) and 1  or  2)

    -- Extract Security Descrptor (make it table type to be ready to pass it to "parse SecDesc")
    ret.nOffsSD  = nStart
    ret.nLenSD   = tonumber(cHdr.SD.nLen)
    ret.SD       = { string.char(string.byte(Data, ret.nOffsSD+1, ret.nOffsSD+ret.nLenSD)) }

    -- There is no GroupName nor MembersList for 0x00010007 format (actually, only /TreeView/SAM/C value is known to have such a format)
    if  not(nFmt == 0x00010007)  then
        ret.nOffsName  = nStart + tonumber(cHdr.Name.nOffs)
        ret.nLenName   = tonumber(cHdr.Name.nLen)
        ret.sGroupName = win.Utf16ToUtf8  (string.char(string.byte(Data, ret.nOffsName+1, ret.nOffsName+ret.nLenName)))

        ret.nOffsComm  = nStart + tonumber(cHdr.Desc.nOffs)
        ret.nLenComm   = tonumber(cHdr.Desc.nLen)
        ret.sGroupComm = win.Utf16ToUtf8  (string.char(string.byte(Data, ret.nOffsComm+1, ret.nOffsComm+ret.nLenComm)))

        -- Explore the group's members list
        ret.nOffsList  = nStart + tonumber(cHdr.nOffsList)
        ret.nLenList   = tonumber(cHdr.nLenList)
        ret.nMembers   = tonumber(cHdr.nMembers)
        ret.Members    = {}

        local nCurOffs = ret.nOffsList
        for i = 1, ret.nMembers do
            if  (nFmt == 0x00010002)  then
                local cRID = ffi.cast ("uint32_t*",  string.char(string.byte(Data, nCurOffs+1, nCurOffs+4)))
                table.insert (ret.Members, {sMemType="RID", nMemOffs=nCurOffs, nMemLen=4, sMemID=string.format("%08X", tonumber(cRID[0]))})
                nCurOffs   = nCurOffs + 4
            else
                local Names,Values,Descs,Offsets,Lengths,Depths = Plugin.SyncCall (GUID, nil, "parse SID", {Data}, nCurOffs)
                table.insert (ret.Members, {sMemType="SID", nMemOffs=nCurOffs, nMemLen=Lengths[1], sMemID=Values[1]})
                nCurOffs   = nCurOffs + Lengths[1]
            end
        end
    end

    return  ret
end

}