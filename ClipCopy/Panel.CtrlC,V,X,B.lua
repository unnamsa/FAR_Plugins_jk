local GUIDclipcopy = "FA871763-7379-4CB4-BDB0-E4EF6FB0B524"

Macro {
  area="Shell Tree"; key="CtrlC"; flags="DisableOutput|EmptyCommandLine"; description="Copy selected file(s) to clipboard";
  condition = function() return Plugin.Exist(GUIDclipcopy) end;
  action = function()
    Plugin.Menu(GUIDclipcopy)
    Keys("1")
  end;
}
Macro {
  area="Shell Tree"; key="CtrlX"; flags="DisableOutput|EmptyCommandLine"; description="Cut selected file(s) to clipboard";
  condition = function() return Plugin.Exist(GUIDclipcopy) end;
  action = function()
    Plugin.Menu(GUIDclipcopy)
    Keys("2")
  end;
}
Macro {
  area="Shell Tree"; key="CtrlV"; flags="DisableOutput"; description="Paste file(s) from clipboard";
  condition = function() return Plugin.Exist(GUIDclipcopy) end;
  action = function()
    Plugin.Menu(GUIDclipcopy)
    Keys("3")
  end;
}
Macro {
  area="Shell Tree"; key="CtrlB"; flags="DisableOutput|EmptyCommandLine"; description="Paste link(s) from file(s) in clipboard";
  condition = function() return Plugin.Exist(GUIDclipcopy) end;
  action = function()
    Plugin.Menu(GUIDclipcopy)
    Keys("4")
  end;
}
