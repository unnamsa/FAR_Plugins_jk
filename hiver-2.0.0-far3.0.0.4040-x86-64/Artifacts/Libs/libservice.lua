return {

--  ServiceType converts the service type into readable form
ServiceType = function (iType)
    local tTypes = {
          [0x0001] = "Kernel driver",
          [0x0002] = "File system driver",
          [0x0004] = "Adapter arguments set",
          [0x0008] = "File system recognizer",
          [0x0010] = "Own_Process",
          [0x0020] = "Share_Process",
          [0x0100] = "Interactive",
          [0x0110] = "Interactive Own_Process",
          [0x0120] = "Interactive Share_Process"
    }
    return  tTypes[iType]  or "Unknown service type"
end,

ServiceStartType = function (iType)
    local tTypes = {
            [0x00] = "Boot Start",
            [0x01] = "System Start",
            [0x02] = "Auto Start",
            [0x03] = "Manual",
            [0x04] = "Disabled"
    }
    return  tTypes[iType]  or "Unknown start type"
end

}