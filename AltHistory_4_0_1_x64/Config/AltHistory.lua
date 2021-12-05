local alt_history_plugin_id = "FF8FC1AE-0F35-4134-9BAB-56D71B1D47B9"
local alt_history_dialog_id = "86ED68B6-7C55-4B2D-AEEB-E354B5F04CA9"

local cfm = {
  show_commands_history = 1,
  show_view_history = 2,
  show_folders_history = 3,
  show_filtered_commands_history = 4,
  set_command_line_to_previsious_command = 5,
  set_command_line_to_next_command = 6,
  get_filter = 7,
  set_filter = 8,
  get_plugin_displayed_prefix = 9,
  get_current_item = 10,
  xlat_filter = 255,
}

local function plugin_call(code, ...) return Plugin.Call(alt_history_plugin_id, code, ...) end

local ah = {}
function ah.is_plugin_exist() return Plugin.Exist(alt_history_plugin_id) end
function ah.show_commands_history() return plugin_call(cfm.show_commands_history) end
function ah.show_view_history() return plugin_call(cfm.show_view_history) end
function ah.show_folders_history() return plugin_call(cfm.show_folders_history) end
function ah.show_filtered_commands_history() return plugin_call(cfm.show_filtered_commands_history) end
function ah.get_filter() return plugin_call(cfm.get_filter) end
function ah.set_filter(filter_str) return plugin_call(cfm.set_filter, filter_str) end
function ah.get_plugin_displayed_prefix(plugin_id) return plugin_call(cfm.get_plugin_displayed_prefix, plugin_id) end
function ah.get_current_item() return plugin_call(cfm.get_current_item) end
function ah.xlat_filter() return plugin_call(cfm.xlat_filter) end
function ah.is_current_history_dialog() return Dlg.Id == alt_history_dialog_id end

local function set_filter_to_current_dir(is_left_panel)
  local F = far.Flags
  local the_panel = APanel.Left == is_left_panel and APanel or PPanel
  local what_panel = APanel.Left == is_left_panel and F.PANEL_ACTIVE or F.PANEL_PASSIVE
  local dir = panel.GetPanelDirectory(nil, what_panel) or {}
  local name = dir.Name
  if the_panel.Plugin then
     local pluginId = win.Uuid(dir.PluginId)
     local file = dir.File
     if file ~= "" then
       name = file .. ":" .. name
     end
     name = ah.get_plugin_displayed_prefix(pluginId) .. ":" .. name
  end
  ah.set_filter(name:lower())
end

-----------------------------------------------------------------------------

-- Macros for replace with AltHistory standard history

Macro {
  description = "Alternative commands history";
  area = "Shell Viewer Editor Info Qview Tree Dialog";
  key = "AltF8";
  condition = ah.is_plugin_exist;
  action = ah.show_commands_history;
}

Macro {
  description = "Alternative file view history";
  area = "Shell Viewer Editor Info Qview Tree Dialog";
  key = "AltF11";
  condition = ah.is_plugin_exist;
  action = ah.show_view_history;
}

Macro {
  description = "Alternative folders history";
  area = "Shell Viewer Editor Info Qview Tree Dialog";
  key  = "AltF12";
  condition = ah.is_plugin_exist;
  action = ah.show_folders_history;
}

Macro {
  description = "Alternative history: list of filtered commands";
  area = "Shell Info Qview Tree";
  key = "CtrlSpace";
  condition = ah.is_plugin_exist;
  action = ah.show_filtered_commands_history;
}

Macro {
  description = "Alternative history: xlat filter";
  area = "Dialog";
  key = "CtrlShiftX";
  condition = ah.is_current_history_dialog;
  action = ah.xlat_filter;
}


-- Macros for call standard history (or other actions)

Macro {
  description = "Go to or Standard commands history";
  area = "Shell Viewer Editor Info Qview Tree";
  key = "CtrlAltF8";
  condition = ah.is_plugin_exist;
  action = function() Keys("AltF8") end;
}

Macro {
  description = "Standard file view history";
  area  ="Shell Viewer Editor Info Qview Tree";
  key = "CtrlAltF11";
  condition = ah.is_plugin_exist;
  action = function() Keys("AltF11") end;
}

Macro {
  description = "Standard folders history";
  area = "Shell Info Qview Tree";
  key = "CtrlAltF12";
  condition = ah.is_plugin_exist;
  action = function() Keys("AltF12") end;
}

-- Useful macros

Macro {
  description = "Alternative history: set filter to left panel's directory";
  area = "Dialog";
  key = "CtrlAlt[";
  condition = function() return ah.is_current_history_dialog and (APanel.Left and APanel or PPanel).FilePanel end;
  action = function() set_filter_to_current_dir(true) end;
}

Macro {
  description = "Alternative history: set filter to right panel's directory";
  area = "Dialog";
  key = "CtrlAlt]";
  condition = function() return ah.is_current_history_dialog and (APanel.Left and PPanel or APanel).FilePanel end;
  action = function() set_filter_to_current_dir(false) end;
}

Macro {
  description = "Alternative history: set filter end to next backslash";
  area = "Dialog";
  key = "CtrlShiftSpace";
  condition = ah.is_current_history_dialog;
  action = function()
    local s, b, e = ah.get_current_item()
    if s ~= nil then
    local ne = s:find("\\", e+1)
    ah.set_filter(s:sub(1, ne):lower())
    end
  end;
}

Macro {
  description = "Alternative history: set filter end to previous backslash";
  area = "Dialog";
  key = "CtrlShiftBS";
  condition = ah.is_current_history_dialog;
  action = function()
    local s, b, e = ah.get_current_item()
    if s ~= nil then
      local ne = e == 0 and 0 or e-1
      while ne > 0 do
        if s:sub(ne, ne) == "\\" then
          break
        end
        ne = ne - 1
      end
    ah.set_filter(s:sub(1, ne):lower())
    end
  end;
}
