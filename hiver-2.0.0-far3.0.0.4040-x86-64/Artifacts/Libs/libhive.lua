return  {

-- HiveType function defines the type of a hive-file based on the hive contents
HiveType = function (HiverGUID, HiveHandle)
    local sName, xValue, nSubItems, sClass

    -- Check for CurrentControlSet (a SYSTEM hive)    
    local bSysHive, nCCS = Plugin.SyncCall (HiverGUID, HiveHandle, "getitem /TreeView/Select/Current")
    bSysHive = bSysHive  and  Plugin.SyncCall (HiverGUID, HiveHandle, "getitem " .. string.format("/TreeView/ControlSet%03d", nCCS))
    if  bSysHive  then
        return "SYSTEM"
    end

    -- Check for the SAM key containing the list of all UserIDs
    local bSamHive       = Plugin.SyncCall (HiverGUID, HiveHandle, "getitem /TreeView/SAM/Domains/Account/Groups/00000201/C")
    if  bSamHive  then
        return "SAM"
    end

    -- Check for the Classes key containing the list of CLSIDs
    local bSoftHive      = Plugin.SyncCall (HiverGUID, HiveHandle, "getitem /TreeView/Classes/CLSID")
    if  bSoftHive  then
        return "SOFTWARE"
    end

    -- Check for the CLSID key containing the list of user's CLSIDs
    local bUCHive        = Plugin.SyncCall (HiverGUID, HiveHandle, "getitem /TreeView/CLSID")
    if  bUCHive  then
        return "USRCLASS"
    end

    -- Check for the Console key containing the User's console params
    local bUsrHive       = Plugin.SyncCall (HiverGUID, HiveHandle, "getitem /TreeView/Console")
    if  bUsrHive  then
        return "NTUSER"
    end

    return "UNKNOWN"
end,


-- GetClass function: returns the Class attribute of a key
GetClass = function (HiverGUID, HiveHandle, sKey)
    local sName, xValue, nSubItems, sClass = Plugin.SyncCall (HiverGUID, HiveHandle, "getitem \"" .. sKey .. "\"")
    return   sClass  or  ""
end,


-- GetValue function: returns the Value attribute of a key
GetValue = function (HiverGUID, HiveHandle, sKey)
    local sName, xValue, nSubItems, sClass = Plugin.SyncCall (HiverGUID, HiveHandle, "getitem \"" .. sKey .. "\"")
    return   xValue
end,


-- TimeStamp function: converts 100-ns timestamp into readable form
TimeStamp = function (HiverGUID, nTime)
    local sDate, sTime = Plugin.SyncCall (HiverGUID, nil, "getfiletime", nTime)
    return  (#sDate == 0)  and  ""  or  sDate .. " " .. sTime
end

}
