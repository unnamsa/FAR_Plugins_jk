local FFE_Guid = "3106d308-a685-415c-96e6-84c8ebb361fe"
Macro {
  description="FastFind Enhanced starter";
  area="Shell"; key="/LAlt./";
  condition=function()
    return jit and Plugin.Exist(FFE_Guid) and APanel.Visible and 40
  end;
  action=function()
    Plugin.Call(FFE_Guid, 1, akey(1,1))
  end;
}