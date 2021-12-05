return  {

CurrentControlSet = function (HiverGUID, HiveHandle)
    local bSysHive, nCCS = Plugin.SyncCall (HiverGUID, HiveHandle, "getitem /TreeView/Select/Current")
    if  bSysHive  then
        return    string.format("ControlSet%03d", nCCS)
    end
    return  nil
end


}
