-- TODO document func 3 and its limitations
-- TODO "hidden paths" in plug panels problem - OPIF_SHOWNAMESONLY
package.path = far.PluginStartupInfo().ModuleDir .. "?.lua;" .. package.path

local _F = far.Flags
local hDlg = nil  --singleton

function export.Configure(guid)
	package.loaded.ffind_cfg = nil
    package.loaded.ffind = nil
	local ffind_cfg = require "ffind_cfg"

	local hDlg = ffind_cfg.create_dialog()
    
    local dlgReturnedValue = far.DialogRun(hDlg)
    if (dlgReturnedValue == 10) then
        ffind_cfg.save_settings(hDlg)
    end

    far.DialogFree(hDlg);

	return true -- success
end

function export.GetPluginInfo ()
  	return {
      Flags = _F.PF_NONE,

      PluginMenuStrings = {far.GetMsg(10)},
      PluginMenuGuids = win.Uuid("8195eb6d-9651-4d60-9a16-ed0d90e20be7"),

      PluginConfigStrings = {far.GetMsg(10)},
      PluginConfigGuids = win.Uuid("22595d6e-fc1e-4317-9935-5e9d3a39bea7")
	}
end

function export.Open(openFrom, guid, item)
    local ffind = require "ffind"

    -- if called from macro, pass the invoking key into ffind dialog
    local akeyPassed = nil

    -- command "2" - get current input string
    if (openFrom==_F.OPEN_FROMMACRO and item.n>=1 and item[1]==2) then
        return hDlg and ffind.get_current_ffind_pattern(hDlg)
    end

    -- command "1" - open with a starting char
    if (openFrom==_F.OPEN_FROMMACRO and item.n>=2 and item[1]==1 and item[2]) then
        akeyPassed = item[2]
    end

    if (hDlg) then return nil end -- singleton

    hDlg = ffind.create_dialog(akeyPassed)
    if (not hDlg) then return nil end

    -- command "3" - open and put in a string as current input
    if (openFrom==_F.OPEN_FROMMACRO and item.n>=2 and item[1]==3 and item[2]) then
        ffind.set_current_ffind_pattern(hDlg, item[2])
    end

	--main loop
    while (not ffind.dieSemaphor) do
        far.DialogRun(hDlg)
    end
    ffind.dieSemaphor = nil

    far.DialogFree(hDlg)

    if (ffind.resendKey) then
    	far.MacroPost ('Keys("'..ffind.resendKey..'")') -- note quotes usage,
    	--   resendKey may contain <'> but not <"> ( <"> is only generated when Alt and Control
    	--   are not pressed, and is checked against filenames inside the dialog)
    	ffind.resendKey = nil
    end
    hDlg = nil

    return true -- cause why not.
end