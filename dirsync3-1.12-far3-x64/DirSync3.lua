local DirSync = {}

function DirSync.ID()
  return "9DABC9DE-4E2A-4B28-9ACD-98BFDA84D3DD"
end

function DirSync.Installed()
  return Plugin.Exist(DirSync.ID())
end

function DirSync.IsEditor()
  return Plugin.SyncCall(DirSync.ID(), "is_editor")
end

function DirSync.IsEditorLine()
  return Plugin.SyncCall(DirSync.ID(), "is_editor_line")
end

function DirSync.ChangeDirection(Direction)
  return Plugin.Call(DirSync.ID(), "change_direction", Direction)
end

function DirSync.ChangeDirectionLeft()
  return DirSync.ChangeDirection("left")
end

function DirSync.ChangeDirectionRight()
  return DirSync.ChangeDirection("right")
end

function DirSync.GoToNextDifference(Direction)
  return Plugin.Call(DirSync.ID(), "next_difference", Direction)
end

function DirSync.GoToNextDifferenceLeft()
  return DirSync.GoToNextDifference("left")
end

function DirSync.GoToNextDifferenceRight()
  return DirSync.GoToNextDifference("right")
end

function DirSync.EditFile(Direction)
  return Plugin.Call(DirSync.ID(), "edit_file", Direction)
end

function DirSync.EditFileLeft()
  return DirSync.EditFile("left")
end

function DirSync.EditFileRight()
  return DirSync.EditFile("right")
end

function DirSync.GoToFile(Direction)
  return Plugin.Call(DirSync.ID(), "goto_file", Direction)
end

function DirSync.GoToFileLeft()
  return DirSync.GoToFile("left")
end

function DirSync.GoToFileRight()
  return DirSync.GoToFile("right")
end

function DirSync.CompareFiles()
  return Plugin.Call(DirSync.ID(), "compare")
end

function DirSync.ShowFileInfo()
  return Plugin.Call(DirSync.ID(), "file_info")
end

Macro
{
  description = "DirSync3 - change synchronization direction to Left";
  area = "Editor";
  key = "AltF1";
  condition = function(key, data)
    return DirSync.Installed() and DirSync.IsEditor();
  end;
  action = function()
    return DirSync.ChangeDirectionLeft();
  end;
}

Macro
{
  description = "DirSync3 - change synchronization direction to Right";
  area = "Editor";
  key = "AltF2";
  condition = function(key, data)
    return DirSync.Installed() and DirSync.IsEditor();
  end;
  action = function()
    return DirSync.ChangeDirectionRight();
  end;
}

Macro
{
  description = "DirSync3 - compare files";
  area = "Editor";
  key = "AltF3";
  condition = function(key, data)
    return DirSync.Installed() and DirSync.IsEditorLine();
  end;
  action = function()
    return DirSync.CompareFiles();
  end;
}

Macro
{
  description = "DirSync3 - go to next difference pointing left";
  area = "Editor";
  key = "AltF5";
  condition = function(key, data)
    return DirSync.Installed() and DirSync.IsEditor();
  end;
  action = function()
    return DirSync.GoToNextDifferenceLeft();
  end;
}

Macro
{
  description = "DirSync3 - go to next difference pointing right";
  area = "Editor";
  key = "AltF6";
  condition = function(key, data)
    return DirSync.Installed() and DirSync.IsEditor();
  end;
  action = function()
    return DirSync.GoToNextDifferenceRight();
  end;
}

Macro
{
  description = "DirSync3 - edit left file";
  area = "Editor";
  key = "CtrlF1";
  condition = function(key, data)
    return DirSync.Installed() and DirSync.IsEditorLine();
  end;
  action = function()
    return DirSync.EditFileLeft();
  end;
}

Macro
{
  description = "DirSync3 - edit right file";
  area = "Editor";
  key = "CtrlF2";
  condition = function(key, data)
    return DirSync.Installed() and DirSync.IsEditorLine();
  end;
  action = function()
    return DirSync.EditFileRight();
  end;
}

Macro
{
  description = "DirSync3 - show file information";
  area = "Editor";
  key = "CtrlF3";
  condition = function(key, data)
    return DirSync.Installed() and DirSync.IsEditorLine();
  end;
  action = function()
    return DirSync.ShowFileInfo();
  end;
}

Macro
{
  description = "DirSync3 - go to left file in panels";
  area = "Editor";
  key = "CtrlF5";
  condition = function(key, data)
    return DirSync.Installed() and DirSync.IsEditorLine();
  end;
  action = function()
    return DirSync.GoToFileLeft();
  end;
}

Macro
{
  description = "DirSync3 - go to right file in panels";
  area = "Editor";
  key = "CtrlF6";
  condition = function(key, data)
    return DirSync.Installed() and DirSync.IsEditorLine();
  end;
  action = function()
    return DirSync.GoToFileRight();
  end;
}

